{ stdenv, lib, buildPythonPackage, fetchPypi, isPyPy, libgit2, six, cffi }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "pygit2";
  version = "0.26.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "29baa530d6fcbf7cca6a75cf9c78fb88613ca81afb39c62fe492f226f6b61800";
  };

  preConfigure = lib.optionalString stdenv.isDarwin ''
    export DYLD_LIBRARY_PATH="${libgit2}/lib"
  '';

  propagatedBuildInputs = [ libgit2 six ] ++ lib.optional (!isPyPy) cffi;

  preCheck = ''
    # disable tests that require networking
    rm test/test_repository.py
    rm test/test_credentials.py
    rm test/test_submodule.py
  '';

  meta = with lib; {
    description = "A set of Python bindings to the libgit2 shared library";
    homepage = https://pypi.python.org/pypi/pygit2;
    license = licenses.gpl2;
  };
}
