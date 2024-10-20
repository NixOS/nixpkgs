{
  buildPythonPackage,
  fetchPypi,
  lib,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "NSKeyedUnArchiver";
  version = "1.2";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-OZWPGH8ggYYKxeg6CGyft6ZM9Yx/43z7YylzXlQcTVg=";
  };

  meta = {
    description = "Unserializes plist data into a usable Python dict";
    homepage = "https://github.com/avibrazil/NSKeyedUnArchiver";
    license = lib.licenses.bsdOriginal;
    maintainers = with lib.maintainers; [ PapayaJackal ];
  };
}
