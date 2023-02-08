{ lib
, buildPythonPackage
, fetchFromGitHub
, flit-core
, arrow
, six
, hypothesis
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "inform";
  version = "1.27";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "KenKundert";
    repo = "inform";
    rev = "refs/tags/v${version}";
    hash = "sha256-SvE+UAGpUomUBHlH4aYZ1BYmLp3BherRjosKsIaOA/s=";
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
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ jeremyschlatter ];
  };
}
