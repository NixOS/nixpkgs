{
  lib,
  fetchPypi,
  buildPythonPackage,
}:

buildPythonPackage rec {
  pname = "pymorphy2-dicts-ru";
  version = "2.4.417127.4579844";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-eMrQOtymBQIavTh6Oy61FchRuG6UaCoe8jVKLHT8wZY=";
  };

  pythonImportsCheck = [ "pymorphy2_dicts_ru" ];

  meta = with lib; {
    description = "Russian dictionaries for pymorphy2";
    homepage = "https://github.com/kmike/pymorphy2-dicts/";
    license = licenses.mit;
    maintainers = [ ];
  };
}
