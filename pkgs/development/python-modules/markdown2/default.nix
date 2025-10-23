{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  latex2mathml,
  pygments,
  pytest7CheckHook,
  pythonOlder,
  setuptools,
  wavedrom,
}:

buildPythonPackage rec {
  pname = "markdown2";
  version = "2.5.4";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "trentm";
    repo = "python-markdown2";
    tag = version;
    hash = "sha256-2w11vVzZUS6HzXmZT+Ag5rPqRnn/tlLnHL4xIDv0l+g=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "markdown2" ];

  nativeCheckInputs = [ pytest7CheckHook ];

  optional-dependencies = {
    code_syntax_highlighting = [ pygments ];
    wavedrom = [ wavedrom ];
    latex = [ latex2mathml ];
    all = lib.flatten (lib.attrValues (lib.filterAttrs (n: v: n != "all") optional-dependencies));
  };

  meta = {
    changelog = "https://github.com/trentm/python-markdown2/blob/${src.tag}/CHANGES.md";
    description = "Fast and complete Python implementation of Markdown";
    mainProgram = "markdown2";
    homepage = "https://github.com/trentm/python-markdown2";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hbunke ];
  };
}
