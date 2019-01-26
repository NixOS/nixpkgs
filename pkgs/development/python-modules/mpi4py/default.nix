{ stdenv, fetchPypi, fetchpatch, python, buildPythonPackage, mpi, openssh }:

buildPythonPackage rec {
  pname = "mpi4py";
  version = "3.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1mzgd26dfv4vwbci8gq77ss9f0x26i9aqzq9b9vs9ndxhlnv0mxl";
  };

  passthru = {
    inherit mpi;
  };

  patches = [ (fetchpatch {
    # Disable tests failing with 3.1.x and MPI_THREAD_MULTIPLE
    url = "https://bitbucket.org/mpi4py/mpi4py/commits/c2b6b7e642a182f9b00a2b8e9db363214470548a/raw";
    sha256 = "0n6bz3kj4vcqb6q7d0mlj5vl6apn7i2bvfc9mpg59vh3wy47119q";
    })
  ];

  postPatch = ''
    substituteInPlace test/test_spawn.py --replace \
                      "unittest.skipMPI('openmpi(<3.0.0)')" \
                      "unittest.skipMPI('openmpi')"
  '';

  configurePhase = "";

  installPhase = ''
    mkdir -p "$out/lib/${python.libPrefix}/site-packages"
    export PYTHONPATH="$out/lib/${python.libPrefix}/site-packages:$PYTHONPATH"

    ${python}/bin/${python.executable} setup.py install \
      --install-lib=$out/lib/${python.libPrefix}/site-packages \
      --prefix="$out"

    # --install-lib:
    # sometimes packages specify where files should be installed outside the usual
    # python lib prefix, we override that back so all infrastructure (setup hooks)
    # work as expected

    # Needed to run the tests reliably. See:
    # https://bitbucket.org/mpi4py/mpi4py/issues/87/multiple-test-errors-with-openmpi-30
    export OMPI_MCA_rmaps_base_oversubscribe=yes
  '';

  setupPyBuildFlags = ["--mpicc=${mpi}/bin/mpicc"];

  buildInputs = [ mpi openssh ];

  meta = {
    description =
      "Python bindings for the Message Passing Interface standard";
    homepage = http://code.google.com/p/mpi4py/;
    license = stdenv.lib.licenses.bsd3;
  };
}
