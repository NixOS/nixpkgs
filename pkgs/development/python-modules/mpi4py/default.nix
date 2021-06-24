{ lib, fetchPypi, fetchpatch, python, buildPythonPackage, mpi, openssh }:

buildPythonPackage rec {
  pname = "mpi4py";
  version = "3.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "012d716c8b9ed1e513fcc4b18e5af16a8791f51e6d1716baccf988ad355c5a1f";
  };

  patches = [ (fetchpatch {
    name = "disable-broken-test"; # upstream patch
    url = "https://github.com/mpi4py/mpi4py/commit/e13cc3ee59ec6ec2c6ee20e384e1e649d5027e8a.patch";
    sha256 = "0iwknrhxnfmsqjj8ahpn50c8pcdyv9p3wmcqi1jhr4i5y7lnmvvx";
  })];

  passthru = {
    inherit mpi;
  };

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

  nativeBuildInputs = [ mpi openssh ];

  meta = with lib; {
    description = "Python bindings for the Message Passing Interface standard";
    homepage = "https://bitbucket.org/mpi4py/mpi4py/";
    license = licenses.bsd3;
  };
}
