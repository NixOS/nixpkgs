{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, unittestCheckHook
}:
buildPythonPackage rec {
  pname = "python-ipware";
  version = "0.9.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "un33k";
    repo = "python-ipware";
    rev = "v${version}";
    hash = "sha256-RK624ktIzoLBD/2mB65zcYZ+o8axDE16bJpB6TwG4h4=";
  };

  pythonImportsCheck = [
    "ipware"
  ];
  nativeCheckInputs = [
    unittestCheckHook
  ];

  meta = with lib; {
    description = "A python package for server applications to retrieve client's IP address";
    homepage = "https://github.com/un33k/python-ipware";
    changelog = "https://github.com/un33k/python-ipware/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ e1mo ];
  };
}
