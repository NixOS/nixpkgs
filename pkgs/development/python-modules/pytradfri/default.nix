{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, pydantic
, aiocoap
, dtlssocket
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pytradfri";
  version = "10.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "pytradfri";
    rev = version;
    hash = "sha256-pEPWKIMooEScQSzhHt0/1UPU1wXP4jbVPPOJkU48fYA=";
  };

  propagatedBuildInputs = [
    pydantic
  ];

  passthru.extras-require = {
    async = [
      aiocoap
      dtlssocket
    ];
  };

  checkInputs = [
    pytestCheckHook
  ]
  ++ passthru.extras-require.async;

  pythonImportsCheck = [
    "pytradfri"
  ];

  meta = with lib; {
    description = "Python package to communicate with the IKEA Trådfri ZigBee Gateway";
    homepage = "https://github.com/home-assistant-libs/pytradfri";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
