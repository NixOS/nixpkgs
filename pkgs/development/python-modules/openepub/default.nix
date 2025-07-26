{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  beautifulsoup4,
  xmltodict,
  pytestCheckHook,
}:
let
  version = "0.0.9";
in
buildPythonPackage {
  inherit version;
  pname = "openepub";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sakolkar";
    repo = "openepub";
    tag = "v${version}";
    hash = "sha256-rk9tM2cC78O9icFpVu5ZH5RI4sbZXWlYOGWOSvwqhDU=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    beautifulsoup4
    xmltodict
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    "test_epub_get_text"
    "test_epub_get_text_2"
    "test_open_epub_from_stream"
    "test_open_get_epub_obj_valid_path"
  ];

  pythonImportsCheck = [ "openepub" ];

  meta = {
    homepage = "https://github.com/sakolkar/openepub";
    changelog = "https://github.com/sakolkar/openepub/releases/tag/v${version}";
    description = "Python library to interact with EPUB files.";
    license = lib.licenses.unlicense;
    maintainers = [ ];
  };
}
