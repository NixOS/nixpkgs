{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools
, glibcLocales
, importlib-resources
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "netaddr";
  version = "0.9.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-e0b6mxotcf1d6eSjeE7zOXAKU6CMgEDwi69fEZTaASg=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  LC_ALL = "en_US.UTF-8";

  propagatedBuildInputs = lib.optionals (pythonOlder "3.7") [ importlib-resources ];

  nativeCheckInputs = [ glibcLocales pytestCheckHook ];

  meta = with lib; {
    homepage = "https://netaddr.readthedocs.io/en/latest/";
    downloadPage = "https://github.com/netaddr/netaddr/releases";
    changelog = "https://netaddr.readthedocs.io/en/latest/changes.html";
    description = "A network address manipulation library for Python";
    license = licenses.mit;
  };
}
