{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fpyutils,
  pyfakefs,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "md-toc";
  version = "9.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "frnmst";
    repo = "md-toc";
    tag = version;
    hash = "sha256-YVDFYxxKMKOrHyymewLTTkmBgg6YVqWou4hTKHJmbOg=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ fpyutils ];

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
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
