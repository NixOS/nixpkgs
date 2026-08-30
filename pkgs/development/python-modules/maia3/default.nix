{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  huggingface-hub,
  numpy,
  chess,
  torch,
}:

buildPythonPackage (finalAttrs: {
  pname = "maia3";
  version = "0.1.0-unstable-2026-05-25";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "CSSLab";
    repo = "maia3";
    rev = "1e13597c42d4858b7cfd7cfdae01e297263364b2";
    hash = "sha256-gDgZTetHVB+KVKNJvAdcgjfvUBNwvWbDra1D8gQDvw8=";
  };

  __structuredAttrs = true;

  # to be updated and removed when https://github.com/CSSLab/maia3/pull/10 is merged
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"python-chess"' '"chess"'
  '';

  build-system = [ setuptools ];

  dependencies = [
    huggingface-hub
    numpy
    chess
    torch
  ];

  pythonImportsCheck = [ "maia3" ];

  meta = {
    description = "Inference tools for Maia3 chess models";
    homepage = "https://github.com/CSSLab/maia3";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ malix ];
    mainProgram = "maia3-uci";
  };
})
