{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, packaging
}:
let
  pname = "lazy-imports";
  version = "0.3.1";
in
buildPythonPackage {
  inherit pname version;
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "telekom";
    repo = "lazy-imports";
    rev = "refs/tags/${version}";
    hash = "sha256-i+VPlBoxNqk56U4oiEgS1Ayhi1t2O8PtLZ/bzEurUY8=";
  };

  pythonImportsCheck = [
    "lazy_imports"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    packaging
  ];

  meta = with lib; {
    description = "Python tool to support lazy imports.";
    homepage = "https://github.com/telekom/lazy-imports";
    changelog = "https://github.com/telekom/lazy-imports/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ happysalada ];
  };
}
