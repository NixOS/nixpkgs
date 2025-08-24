{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  hatch-vcs,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "ar";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "vidstige";
    repo = "ar";
    tag = "v${version}";
    hash = "sha256-azbqlSO5YE6zMrDoVNLDyGeed5H4mSyNEE02AmoZIDs=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    hatch-vcs
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "ar" ];

  disabledTests = lib.optionals stdenv.isDarwin [
    "test_list"
    "test_read_content"
    "test_read_binary"
    "test_read_content_ext"
    "test_read_binary_ext"
  ];

  meta = {
    description = "Implementation of the ar archive format";
    homepage = "https://github.com/vidstige/ar";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ethancedwards8 ];
  };
}
