{
  buildPythonPackage,
  eliot,
  fetchPypi,
  google-search-results,
  jinja2,
  lib,
  manifest-ml,
  openai,
  pytestCheckHook,
  pythonAtLeast,
  pythonRelaxDepsHook,
}:

buildPythonPackage rec {
  pname = "minichain";
  version = "0.3.3";
  format = "setuptools";

  # See https://github.com/NixOS/nixpkgs/pull/248195#issuecomment-1687398702.
  disabled = pythonAtLeast "3.11";

  # See https://github.com/srush/MiniChain/issues/23 and https://github.com/NixOS/nixpkgs/issues/248185 as to why we
  # don't fetchFromGitHub.
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+mju1Mz/aojROpiOVzv6WoRNTrhgCub4yyYLEWcHWh0=";
  };

  # See https://github.com/srush/MiniChain/issues/24.
  postPatch = ''
    substituteInPlace ./minichain/__init__.py --replace "from .gradio import GradioConf, show" ""
  '';

  nativeBuildInputs = [ pythonRelaxDepsHook ];

  pythonRemoveDeps = [
    # Only used in the examples:
    "datasets"
    "faiss-cpu"
    "jinja2-highlight"
    "trio"

    # Not used anywhere:
    "eliot-tree"

    # Not yet packaged in nixpkgs:
    "gradio"
  ];

  # Some of these could be made optional. Certain packages are used by certain backends.
  propagatedBuildInputs = [
    eliot
    google-search-results
    jinja2
    manifest-ml
    openai
  ];

  # As of 0.3.3, the PyPI distribution does not include any tests.
  doCheck = false;

  pythonImportsCheck = [ "minichain" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Tiny library for coding with large language models";
    homepage = "https://srush-minichain.hf.space";
    changelog = "https://github.com/srush/MiniChain/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ samuela ];
  };
}
