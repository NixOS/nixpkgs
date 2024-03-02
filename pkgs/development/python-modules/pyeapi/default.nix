{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, mock
, netaddr
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyeapi";
  version = "1.0.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "arista-eosplus";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-GZBoCoAqij54rZezRDF/ihJDQ5T6FFyDSRXGV3//avQ=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    netaddr
  ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "test/unit"
  ];

  pythonImportsCheck = [
    "pyeapi"
  ];

  meta = with lib; {
    description = "Client for Arista eAPI";
    homepage = "https://github.com/arista-eosplus/pyeapi";
    license = licenses.bsd3;
    maintainers = with maintainers; [ astro ];
  };
}
