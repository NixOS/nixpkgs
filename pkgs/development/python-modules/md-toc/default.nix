{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fpyutils,
  hatchling,
  pyfakefs,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "md-toc";
  version = "9.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "frnmst";
    repo = "md-toc";
    tag = version;
    hash = "sha256-dgbAAaQDxeOkJV+XI9ZTaHPhrLUrm7v5zFr9LVT48ow=";
  };

  build-system = [ hatchling ];

  dependencies = [ fpyutils ];

  nativeCheckInputs = [
    pyfakefs
    pytestCheckHook
  ];

  # Only run the real unit-test module; the over-broad glob also collected
  # md_toc/tests/fuzzer.py, which imports the unpackaged `atheris` engine.
  # https://github.com/frnmst/md-toc/blob/9.0.0/md_toc/tests/fuzzer.py#L22
  enabledTestPaths = [ "md_toc/tests/tests.py" ];

  pythonImportsCheck = [ "md_toc" ];

  meta = {
    description = "Table of contents generator for Markdown";
    mainProgram = "md_toc";
    homepage = "https://docs.franco.net.eu.org/md-toc/";
    changelog = "https://blog.franco.net.eu.org/software/CHANGELOG-md-toc.html";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ fab ];
  };
}
