{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  more-itertools,
  typeguard,

  # checks
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "inflect";
  version = "7.4.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "jaraco";
    repo = "inflect";
    rev = "refs/tags/v${version}";
    hash = "sha256-3I5AdMuxwKtztnrF0lbvBIUxfqn0WlY2Pv6GYitFrA8=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

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

  meta = {
    description = "Correctly generate plurals, singular nouns, ordinals, indefinite articles";
    homepage = "https://github.com/jaraco/inflect";
    changelog = "https://github.com/jaraco/inflect/blob/v${version}/CHANGES.rst";
    license = lib.licenses.mit;
    maintainers = lib.teams.tts.members;
  };
}
