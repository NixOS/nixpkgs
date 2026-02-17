{
  fetchFromGitHub,
  lib,
  buildPythonPackage,
  git,
  which,
  unittestCheckHook,
  sphinxHook,
  sphinx-argparse,
  parameterized,
  setuptools,
  nix,
}:

buildPythonPackage rec {
  pname = "nix-prefetch-github";
  version = "7.1.0";
  pyproject = true;

  outputs = [
    "out"
    "man"
  ];

  src = fetchFromGitHub {
    owner = "seppeljordan";
    repo = "nix-prefetch-github";
    rev = "v${version}";
    hash = "sha256-eQd/MNlnuzXzgFzvwUMchvHoIvkIrbpGKV7iknO14Cc=";
  };

  dependencies = [ nix ];

  nativeBuildInputs = [
    sphinxHook
    sphinx-argparse
    setuptools
  ];
  nativeCheckInputs = [
    unittestCheckHook
    git
    which
    parameterized
  ];

  sphinxBuilders = [ "man" ];
  sphinxRoot = "docs";

  # ignore tests which are impure
  DISABLED_TESTS = "network requires_nix_build";

  meta = {
    description = "Prefetch sources from github";
    homepage = "https://github.com/seppeljordan/nix-prefetch-github";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ seppeljordan ];
  };
}
