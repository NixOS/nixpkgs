{ lib
, buildPythonPackage
, isPy3k
, fetchFromGitHub
, mkdocs
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "mkdocs-simple-hooks";
  version = "0.1.5";

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "aklajnert";
    repo = "mkdocs-simple-hooks";
    rev = "v${version}";
    hash = "sha256-N6xZjCREjJlhR6f8m65WJswUQv/TTdTbk670+C46UWQ=";
  };

  propagatedBuildInputs = [
    mkdocs
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [ "tests.py" ];

  # disable failing tests
  disabledTests = [
    "test_no_hooks_defined"
    "test_no_attribute"
  ];

  meta = with lib; {
    description = "Define your own hooks for mkdocs, without having to create a new package.";
    homepage = "https://github.com/aklajnert/mkdocs-simple-hooks";
    license = licenses.mit;
    maintainers = with maintainers; [ arjan-s ];
  };
}
