{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  pytestCheckHook,
  ruamel-yaml,
  setuptools,
}:

buildPythonPackage rec {
  pname = "cwlformat";
  version = "2022.02.18";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rabix";
    repo = "cwl-format";
    tag = version;
    hash = "sha256-FI8hUgb/KglTkubZ+StzptoSsYal71ITyyFNg7j48yk=";
  };

  patches = [
    # https://github.com/rabix/cwl-format/pull/21
    (fetchpatch {
      name = "fix-for-ruamel-yaml-0.17.23.patch";
      url = "https://github.com/rabix/cwl-format/commit/9d54330c73c454d2ccacd55e2d51a4145f282041.patch";
      hash = "sha256-TZGK7T2gzxMvreCLtl3nkuPrqL2KzgrO3yCNmd5lY3g=";
    })
  ];

  build-system = [ setuptools ];

  dependencies = [ ruamel-yaml ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "cwlformat" ];

  disabledTests = [
    # Test compares output
    "test_formatting_battery"
  ];

  meta = {
    description = "Code formatter for CWL";
    homepage = "https://github.com/rabix/cwl-format";
    changelog = "https://github.com/rabix/cwl-format/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
