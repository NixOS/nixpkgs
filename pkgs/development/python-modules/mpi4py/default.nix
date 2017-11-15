{ stdenv, fetchPypi, python, buildPythonPackage, mpi }:

buildPythonPackage rec {
  pname = "mpi4py";
  version = "3.0.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1mzgd26dfv4vwbci8gq77ss9f0x26i9aqzq9b9vs9ndxhlnv0mxl";
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

  meta = {
    description =
      "Python bindings for the Message Passing Interface standard";
    homepage = http://code.google.com/p/mpi4py/;
    license = stdenv.lib.licenses.bsd3;
  };
}
