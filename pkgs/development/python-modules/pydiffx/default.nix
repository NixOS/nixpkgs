{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  six,
  pytestCheckHook,
  kgb,
}:

buildPythonPackage rec {
  pname = "pydiffx";
  version = "1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "beanbaginc";
    repo = "diffx";
    tag = "pydiffx/release-${version}";
    hash = "sha256-oJjHrg1X02SmNJKbWbTPc0kycI+jLj0C4eUFFXwb+TA=";
  };

  sourceRoot = "${src.name}/python";

  postPatch = ''
    substituteInPlace pydiffx/tests/testcases.py \
      --replace-fail "assertRaisesRegexp" "assertRaisesRegex"
  '';

  build-system = [ setuptools ];

  dependencies = [ six ];

  pythonImportsCheck = [ "pydiffx" ];

  nativeCheckInputs = [
    pytestCheckHook
    kgb
  ];

  meta = {
    description = "DiffX file format and utilities";
    homepage = "https://github.com/beanbaginc/diffx";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
