{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "docstring-to-markdown";
  version = "0.17";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "python-lsp";
    repo = "docstring-to-markdown";
    tag = "v${version}";
    hash = "sha256-conwwToBrlDL487zf2ldCOxFFKxP1a8LnU0KocI8riI=";
  };

  postPatch = ''
    sed -i -E '/--(cov|flake8)/d' setup.cfg
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "docstring_to_markdown" ];

  meta = with lib; {
    homepage = "https://github.com/python-lsp/docstring-to-markdown";
    description = "On the fly conversion of Python docstrings to markdown";
    changelog = "https://github.com/python-lsp/docstring-to-markdown/releases/tag/${src.tag}";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ doronbehar ];
  };
}
