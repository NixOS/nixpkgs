{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  uv-build,

  # dependencies
  pytest,

  # tests
  pytestCheckHook,
}:

let
  pname = "pytest-describe";
  version = "3.0.0";
in
buildPythonPackage {
  inherit pname version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pytest-dev";
    repo = "pytest-describe";
    tag = version;
    hash = "sha256-rMO+Hkz3iWFML8UUq4aDl+t7epzqXmYGZrgRB9OYf6w=";
  };

  build-system = [ uv-build ];

  buildInputs = [ pytest ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Describe-style plugin for the pytest framework";
    homepage = "https://github.com/pytest-dev/pytest-describe";
    changelog = "https://github.com/pytest-dev/pytest-describe/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
