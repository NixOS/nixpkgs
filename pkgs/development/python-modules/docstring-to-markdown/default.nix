{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "docstring-to-markdown";
  version = "0.15";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "python-lsp";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-ykqY7LFIOTuAddYkKDzIltq8FpLVz4v2ZA3Y0cZH9ms=";
  };

  postPatch = ''
    sed -i -E '/--(cov|flake8)/d' setup.cfg
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "docstring_to_markdown" ];

  meta = with lib; {
    homepage = "https://github.com/python-lsp/docstring-to-markdown";
    description = "On the fly conversion of Python docstrings to markdown";
    changelog = "https://github.com/python-lsp/docstring-to-markdown/releases/tag/v${version}";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ doronbehar ];
  };
}
