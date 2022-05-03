{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aioslimproto";
  version = "1.0.2";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-cJsu8BrDrJqotkXH5jPbAMsftWCbF8tbpH/4CCzWWI0=";
  };

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "aioslimproto"
  ];

  meta = with lib; {
    description = "Module to control Squeezebox players";
    homepage = "https://github.com/home-assistant-libs/aioslimproto";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
