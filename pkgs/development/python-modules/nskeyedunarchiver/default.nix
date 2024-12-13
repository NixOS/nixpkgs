{
  buildPythonPackage,
  fetchPypi,
  lib,
  setuptools,
}:

buildPythonPackage rec {
  pname = "nskeyedunarchiver";
  version = "1.2";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "NSKeyedUnArchiver";
    hash = "sha256-OZWPGH8ggYYKxeg6CGyft6ZM9Yx/43z7YylzXlQcTVg=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "NSKeyedUnArchiver" ];

  meta = {
    description = "Unserializes plist data into a usable Python dict";
    homepage = "https://github.com/avibrazil/NSKeyedUnArchiver";
    license = lib.licenses.bsdOriginal;
    maintainers = with lib.maintainers; [ PapayaJackal ];
  };
}
