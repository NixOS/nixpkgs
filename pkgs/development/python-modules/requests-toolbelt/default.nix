{ lib
, betamax
, buildPythonPackage
, fetchPypi
, pyopenssl
, pytestCheckHook
, requests
, trustme
}:

buildPythonPackage rec {
  pname = "requests-toolbelt";
  version = "1.0.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-doGgo9BHAStb3A7jfX+PB+vnarCMrsz8OSHOI8iNW8Y=";
  };

  propagatedBuildInputs = [
    requests
  ];

  nativeCheckInputs = [
    betamax
    pyopenssl
    pytestCheckHook
    trustme
  ];

  pythonImportsCheck = [
    "requests_toolbelt"
  ];

  meta = with lib; {
    description = "Toolbelt of useful classes and functions to be used with requests";
    homepage = "http://toolbelt.rtfd.org";
    changelog = "https://github.com/requests/toolbelt/blob/${version}/HISTORY.rst";
    license = licenses.asl20;
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}
