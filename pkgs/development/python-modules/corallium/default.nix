{
  beartype,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  rich,
  tomli,
  typing-extensions,
  uv-build,
}:
buildPythonPackage rec {
  pname = "corallium";
  version = "2.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "KyleKing";
    repo = "corallium";
    tag = version;
    hash = "sha256-BtePG2XcukAytbNyIfH3rBesx7nu7J1TLtfbzZO37Os=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.9.26,<2.0" "uv_build"
    # Upstream declares a bogus self-dependency which breaks the runtime deps check
    substituteInPlace pyproject.toml --replace-fail "'corallium>=2.0.1'," ""
  '';

  build-system = [
    uv-build
  ];

  dependencies = [
    beartype
    rich
    tomli
    typing-extensions
  ];

  # Top-level __init__ pulls the full subpackage tree; no optional deps needed
  pythonImportsCheck = [ "corallium" ];

  # tests/ requires dev deps (structlog, pytest-*) not worth packaging here

  meta = {
    description = "Shared functionality for the calcipy-ecosystem";
    homepage = "https://corallium.kyleking.me";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yajo ];
  };
}
