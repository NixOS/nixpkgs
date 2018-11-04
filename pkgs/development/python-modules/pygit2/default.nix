{ stdenv, lib, buildPythonPackage, fetchPypi, isPyPy, libgit2, six, cffi }:

buildPythonPackage rec {
  pname = "pygit2";
  version = "0.27.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fcc293c54bdca8d0e270fd8bfa2e7a63243e093bbdb222c1efb240665a7f2b35";
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
