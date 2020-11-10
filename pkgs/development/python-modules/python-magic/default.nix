{ buildPythonPackage, lib, fetchPypi, file, stdenv }:

buildPythonPackage rec {
  pname = "python-magic";
  version = "0.4.18";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b757db2a5289ea3f1ced9e60f072965243ea43a2221430048fd8cacab17be0ce";
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
    homepage = "https://github.com/ahupp/python-magic";
    license = lib.licenses.mit;
  };
}
