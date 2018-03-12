{ buildPythonPackage, lib, fetchPypi, file, stdenv }:

buildPythonPackage rec {
  pname = "python-magic";
  version = "0.4.15";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f3765c0f582d2dfc72c15f3b5a82aecfae9498bd29ca840d72f37d7bd38bfcd5";
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
