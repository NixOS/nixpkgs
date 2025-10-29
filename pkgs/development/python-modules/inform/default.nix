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
  pythonOlder,
  pythonAtLeast,
}:

buildPythonPackage rec {
  pname = "inform";
  version = "1.35";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "KenKundert";
    repo = "inform";
    tag = "v${version}";
    hash = "sha256-FQc8R4MJ5RKJi70ADboy2Lw6IwLaI3hup60GcnPxV60=";
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

  meta = with lib; {
    description = "Print and logging utilities";
    longDescription = ''
      Inform is designed to display messages from programs that are typically
      run from a console. It provides a collection of ‘print’ functions that
      allow you to simply and cleanly print different types of messages.
    '';
    homepage = "https://inform.readthedocs.io";
    changelog = "https://github.com/KenKundert/inform/blob/${src.tag}/doc/releases.rst";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ jeremyschlatter ];
  };
}
