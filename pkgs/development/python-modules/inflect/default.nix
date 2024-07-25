{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  more-itertools,
  setuptools-scm,
  pytestCheckHook,
  typeguard,
}:

buildPythonPackage rec {
  pname = "inflect";
  version = "7.3.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "jaraco";
    repo = "inflect";
    rev = "refs/tags/v${version}";
    hash = "sha256-J0XgSKPzZIt/7WnMGARXpyYzagBGiqRiuNmNnGKDBrs=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [
    more-itertools
    typeguard
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # https://errors.pydantic.dev/2.5/v/string_too_short
    "inflect.engine.compare"
  ];

  pythonImportsCheck = [ "inflect" ];

  meta = with lib; {
    description = "Correctly generate plurals, singular nouns, ordinals, indefinite articles";
    homepage = "https://github.com/jaraco/inflect";
    changelog = "https://github.com/jaraco/inflect/blob/v${version}/CHANGES.rst";
    license = licenses.mit;
    maintainers = teams.tts.members;
  };
}
