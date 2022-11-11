{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, aiocoap
, dtlssocket
, pydantic
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pytradfri";
  version = "11.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "pytradfri";
    rev = "refs/tags/${version}";
    hash = "sha256-+OOmoh2HLKiHAqOIH2aB4CZcW/ND/0bszgkcdRMYBlc=";
  };

  propagatedBuildInputs = [
    pydantic
  ];

  passthru.optional-dependencies = {
    async = [
      aiocoap
      dtlssocket
    ];
  };

  checkInputs = [
    pytestCheckHook
  ]
  ++ passthru.optional-dependencies.async;

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
