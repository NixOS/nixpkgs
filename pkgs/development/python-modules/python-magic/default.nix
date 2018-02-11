{ buildPythonPackage, lib, fetchPypi, file, stdenv }:

buildPythonPackage rec {
  pname = "python-magic";
  version = "0.4.13";

  src = fetchPypi {
    inherit pname version;
    sha256 = "128j9y30zih6cyjyjnxhghnvpjm8vw40a1q7pgmrp035yvkaqkk0";
  };

  postPatch = ''
    substituteInPlace magic.py --replace "ctypes.util.find_library('magic')" "'${file}/lib/libmagic${stdenv.hostPlatform.extensions.sharedLibrary}'"
  '';

  doCheck = false;

  # TODO: tests are failing
  #checkPhase = ''
  #  ${python}/bin/${python.executable} ./test.py
  #'';

  meta = {
    description = "A python interface to the libmagic file type identification library";
    homepage = https://github.com/ahupp/python-magic;
    license = lib.licenses.mit;
  };
}
