{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "py-sonic";
  version = "1.1.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-WzygTPYcqqifF2K21DfMw4bjALVglGS3MOijYXwb0dk=";
  };

  # package has no tests
  doCheck = false;
  pythonImportsCheck = [ "libsonic" ];

  meta = {
    homepage = "https://github.com/crustymonkey/py-sonic";
    description = "Python wrapper library for the Subsonic REST API";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ wenngle ];
  };
}
