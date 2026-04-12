{
  lib,
  atheris,
  buildPythonPackage,
  fetchFromGitHub,
  fpyutils,
  pyfakefs,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "md-toc";
  version = "9.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "frnmst";
    repo = "md-toc";
    tag = finalAttrs.version;
    hash = "sha256-YVDFYxxKMKOrHyymewLTTkmBgg6YVqWou4hTKHJmbOg=";
  };

  build-system = [ setuptools ];

  dependencies = [
    atheris
    fpyutils
  ];

  nativeCheckInputs = [
    pyfakefs
    pytestCheckHook
  ];

  enabledTestPaths = [ "md_toc/tests/*.py" ];

  pythonImportsCheck = [ "md_toc" ];

  meta = {
    description = "Table of contents generator for Markdown";
    homepage = "https://docs.franco.net.eu.org/md-toc/";
    changelog = "https://blog.franco.net.eu.org/software/CHANGELOG-md-toc.html";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "md_toc";
  };
})
