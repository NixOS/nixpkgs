{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "readlike";
  version = "0.1.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "jangler";
    repo = "readlike";
    rev = version;
    hash = "sha256-gWFkKrp9nyhYUSS89MfQJXISnbs8akH+ahgi3RSSiNc=";
  };

  nativeCheckInputs = [ unittestCheckHook ];

  unittestFlagsArray = [
    "-s"
    "tests"
  ];

  meta = {
    description = "GNU Readline-like line editing module";
    homepage = "https://github.com/jangler/readlike";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
