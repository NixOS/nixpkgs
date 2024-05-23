{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  lxml,
  numpy,
  pytestCheckHook,
  scikit-image,
}:
let
  version = "1.2";
in
buildPythonPackage {
  pname = "mung";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "OMR-Research";
    repo = "mung";
    rev = "refs/tags/${version}";
    hash = "sha256-NSKaJkJRevTy5gh6/ik8Qe46bOPdznsmXPgh7Xz7vXQ=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    lxml
    numpy
    scikit-image
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "mung" ];

  meta = with lib; {
    description = "Music Notation Graph: a data model for optical music recognition";
    homepage = "https://github.com/OMR-Research/mung";
    changelog = "https://github.com/OMR-Research/mung/blob/${version}/CHANGES.md";
    license = licenses.mit;
    maintainers = with maintainers; [ piegames ];
  };
}
