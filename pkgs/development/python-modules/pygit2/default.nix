{ stdenv, lib, buildPythonPackage, fetchPypi, isPyPy, libgit2, six, cffi }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "pygit2";
  version = "0.27.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1aa5ba1d59370bda158950ba4849bb6e59f13ac7e6fca5e392bfd873bd2c1cf9";
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
