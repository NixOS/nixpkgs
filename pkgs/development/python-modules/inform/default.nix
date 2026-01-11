{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  arrow,
  six,
  hypothesis,
  num2words,
  pytestCheckHook,
  pythonAtLeast,
}:

buildPythonPackage rec {
  pname = "inform";
  version = "1.36";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "KenKundert";
    repo = "inform";
    tag = "v${version}";
    hash = "sha256-x2xLEcywMaYhq/SWPVu48zTHJW3/MWujjr4y6/uEClU=";
  };

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [
    arrow
    six
  ];

  nativeCheckInputs = [
    num2words
    pytestCheckHook
    hypothesis
  ];

  disabledTests = [
    "test_prostrate"
  ]
  ++ lib.optionals (pythonAtLeast "3.13") [
    # doctest runs one more test than expected
    "test_inform"
  ];

  meta = {
    description = "Print and logging utilities";
    longDescription = ''
      Inform is designed to display messages from programs that are typically
      run from a console. It provides a collection of ‘print’ functions that
      allow you to simply and cleanly print different types of messages.
    '';
    homepage = "https://inform.readthedocs.io";
    changelog = "https://github.com/KenKundert/inform/blob/${src.tag}/doc/releases.rst";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ jeremyschlatter ];
  };
}
