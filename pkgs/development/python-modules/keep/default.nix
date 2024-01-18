{ lib
, buildPythonPackage
, fetchPypi
, pygithub
, terminaltables
, click
, requests
}:

buildPythonPackage rec {
  pname = "keep";
  version = "2.10.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3abbe445347711cecd9cbb80dab4a0777418972fc14a14e9387d0d2ae4b6adb7";
  };

  propagatedBuildInputs = [
    click
    requests
    terminaltables
    pygithub
  ];

  # no tests
  doCheck = false;
  pythonImportsCheck = [ "keep" ];

  meta = with lib; {
    homepage = "https://github.com/orkohunter/keep";
    description = "A Meta CLI toolkit: Personal shell command keeper and snippets manager";
    platforms = platforms.all;
    license = licenses.mit;
    maintainers = with maintainers; [ ris ];
  };
}
