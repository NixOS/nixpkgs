{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  lark,
  lxml,
  oletools,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "rtfde";
  version = "0.1.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "seamustuohy";
    repo = "RTFDE";
    tag = version;
    hash = "sha256-1yjxp6N07I9kwFRtgsLo9UPSG4FU+ic1tNm6U/xWk74=";
  };

  build-system = [ setuptools ];

  pythonRelaxDeps = [ "lark" ];

  dependencies = [
    lark
    oletools
  ];

  nativeCheckInputs = [
    lxml
    pytestCheckHook
  ];

  pythonImportsCheck = [ "RTFDE" ];

  disabledTests = [
    # Malformed encapsulated RTF discovered
    "test_encoded_bytes_stay_encoded_character"
  ];

  meta = {
    changelog = "https://github.com/seamustuohy/RTFDE/releases/tag/${src.tag}";
    description = "Library for extracting encapsulated HTML and plain text content from the RTF bodies";
    homepage = "https://github.com/seamustuohy/RTFDE";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ fab ];
  };
}
