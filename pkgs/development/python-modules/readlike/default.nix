{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  unittestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "readlike";
  version = "0.1.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "jangler";
    repo = "readlike";
    tag = finalAttrs.version;
    hash = "sha256-gWFkKrp9nyhYUSS89MfQJXISnbs8akH+ahgi3RSSiNc=";
  };

  nativeCheckInputs = [ unittestCheckHook ];

  unittestFlags = [
    "--start-directory=tests"
  ];

  meta = {
    description = "GNU Readline-like line editing module";
    homepage = "https://github.com/jangler/readlike";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
