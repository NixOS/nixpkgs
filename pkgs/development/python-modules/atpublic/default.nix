{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  pytestCheckHook,
  pythonOlder,
  hatchling,
  sybil,
}:

buildPythonPackage rec {
  pname = "atpublic";
  version = "5.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitLab {
    owner = "warsaw";
    repo = "public";
    rev = "refs/tags/${version}";
    hash = "sha256-cqum+4hREu0jO9iFoUUzfzn597BoMAhG+aanwnh8hb8=";
  };

  build-system = [ hatchling ];

  nativeCheckInputs = [
    pytestCheckHook
    sybil
  ];

  pythonImportsCheck = [ "public" ];

  meta = with lib; {
    changelog = "https://gitlab.com/warsaw/public/-/blob/${version}/docs/NEWS.rst";
    description = "Python decorator and function which populates a module's __all__ and globals";
    homepage = "https://public.readthedocs.io/";
    longDescription = ''
      This is a very simple decorator and function which populates a module's
      __all__ and optionally the module globals.
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ eadwu ];
  };
}
