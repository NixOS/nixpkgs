{ lib
, buildPythonPackage
, fetchFromGitHub
, flit-core
, arrow
, six
, hypothesis
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "inform";
  version = "1.28";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "KenKundert";
    repo = "inform";
    rev = "refs/tags/v${version}";
    hash = "sha256-RA8/or3HTS/rQmG4A/Eg5j24YElaTEpnHa1yksARVMQ=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    arrow
    six
  ];

  nativeCheckInputs = [
    pytestCheckHook
    hypothesis
  ];

  disabledTests = [
    "test_prostrate"
  ];

  meta = with lib; {
    description = "Print and logging utilities";
    longDescription = ''
      Inform is designed to display messages from programs that are typically
      run from a console. It provides a collection of ‘print’ functions that
      allow you to simply and cleanly print different types of messages.
    '';
    homepage = "https://inform.readthedocs.io";
    changelog = "https://github.com/KenKundert/inform/blob/v${version}/doc/releases.rst";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ jeremyschlatter ];
  };
}
