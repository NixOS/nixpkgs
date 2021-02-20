{ buildPythonPackage, lib, fetchPypi, file, stdenv }:

buildPythonPackage rec {
  pname = "python-magic";
  version = "0.4.22";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ca884349f2c92ce830e3f498c5b7c7051fe2942c3ee4332f65213b8ebff15a62";
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
