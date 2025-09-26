{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  pytest,

  # tests
  pytest7CheckHook,
}:

let
  pname = "pytest-describe";
  version = "2.2.0";
in
buildPythonPackage {
  inherit pname version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pytest-dev";
    repo = "pytest-describe";
    tag = version;
    hash = "sha256-ih0XkYOtB+gwUsgo1oSti2460P3gq3tR+UsyRlzMjLE=";
  };

  build-system = [ setuptools ];

  buildInputs = [ pytest ];

  # test_fixture breaks with pytest 8.4
  nativeCheckInputs = [ pytest7CheckHook ];

  meta = with lib; {
    description = "Describe-style plugin for the pytest framework";
    homepage = "https://github.com/pytest-dev/pytest-describe";
    changelog = "https://github.com/pytest-dev/pytest-describe/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
