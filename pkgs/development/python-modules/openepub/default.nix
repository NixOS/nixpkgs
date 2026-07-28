{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  beautifulsoup4,
  xmltodict,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "openepub";
  version = "0.0.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sakolkar";
    repo = "openepub";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rk9tM2cC78O9icFpVu5ZH5RI4sbZXWlYOGWOSvwqhDU=";
  };

  build-system = [
    hatchling
  ];

  # Upstream caps xmltodict at <1; only xmltodict.parse() is used and its
  # signature is unchanged in 1.x.
  pythonRelaxDeps = [ "xmltodict" ];

  dependencies = [
    beautifulsoup4
    xmltodict
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # These tests read the EPUB fixtures test/mock/tödliche_lektion.epub and
  # test/mock/philosophers_stone.epub, which are copyrighted books that
  # upstream does not redistribute in the repository.
  disabledTests = [
    "test_epub_get_text"
    "test_epub_get_text_2"
    "test_open_epub_from_stream"
    "test_open_get_epub_obj_valid_path"
  ];

  pythonImportsCheck = [ "openepub" ];

  meta = {
    homepage = "https://github.com/sakolkar/openepub";
    changelog = "https://github.com/sakolkar/openepub/releases/tag/${finalAttrs.src.tag}";
    description = "Python library to interact with EPUB files";
    license = lib.licenses.unlicense;
    maintainers = [ lib.maintainers.imalison ];
  };
})
