{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "paste";
  version = "3.11.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pasteorg";
    repo = "paste";
    tag = finalAttrs.version;
    hash = "sha256-5eQU9pHazxKX9zMEd7oghKCke//uN4BVnmwYMR5lnSE=";
  };

  postPatch = ''
    patchShebangs tests/cgiapp_data/
  '';

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    # needs to be modified after Sat, 1 Jan 2005 12:00:00 GMT
    touch tests/urlparser_data/secured.txt
  '';

  pythonNamespaces = [ "paste" ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Tools for using a Web Server Gateway Interface stack";
    homepage = "https://pythonpaste.readthedocs.io/";
    changelog = "https://github.com/pasteorg/paste/blob/${finalAttrs.version}/docs/news.txt";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
