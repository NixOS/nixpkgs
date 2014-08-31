{ stdenv, fetchurl, python, buildPythonPackage, mpi, openssh }:

buildPythonPackage rec {
  name = "mpi4py-1.3.1";

  src = fetchurl {
    url = "https://bitbucket.org/mpi4py/mpi4py/downloads/${name}.tar.gz";
    sha256 = "e7bd2044aaac5a6ea87a87b2ecc73b310bb6efe5026031e33067ea3c2efc3507";
  };

  passthru = {
    inherit mpi;
  };

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
  '';

  setupPyBuildFlags = ["--mpicc=${mpi}/bin/mpicc"];

  buildInputs = [ mpi ];
  # Requires openssh for tests. Tests of dependent packages will also fail,
  # if openssh is not present. E.g. h5py with mpi support.
  propagatedBuildInputs = [ openssh ];

  meta = {
    description = "
      Provides Python bindings for the Message Passing Interface standard.
    ";
    homepage = "http://code.google.com/p/mpi4py/";
    license = stdenv.lib.licenses.bsd3;
  };
}
