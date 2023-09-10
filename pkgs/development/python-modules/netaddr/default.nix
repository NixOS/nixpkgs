{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, glibcLocales
, importlib-resources
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "netaddr";
  version = "0.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0hx2npi0wnhwlcybilgwlddw6qffx1mb7a3sj4p9s7bvl33mgk6n";
  };

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
