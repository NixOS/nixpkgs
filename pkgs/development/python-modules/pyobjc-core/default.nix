{
  buildPythonPackage,
  darwin,
  fetchFromGitHub,
  lib,
  setuptools,

  # TODO: Clean up on `staging`.
  llvmPackages,
}:

buildPythonPackage rec {
  pname = "pyobjc-core";
  version = "11.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ronaldoussoren";
    repo = "pyobjc";
    tag = "v${version}";
    hash = "sha256-2qPGJ/1hXf3k8AqVLr02fVIM9ziVG9NMrm3hN1de1Us=";
  };

  sourceRoot = "${src.name}/pyobjc-core";

  build-system = [ setuptools ];

  buildInputs = [
    darwin.libffi
  ];

  nativeBuildInputs = [
    darwin.DarwinTools # sw_vers

    # TODO: Clean up on `staging`.
    llvmPackages.lld
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    "-I${darwin.libffi.dev}/include"
    "-Wno-error=cast-function-type-mismatch"
    "-Wno-error=unused-command-line-argument"
  ];

  # TODO: Clean up on `staging`.
  env.NIX_CFLAGS_LINK = "-fuse-ld=lld";

  pythonImportsCheck = [ "objc" ];

  meta = {
    description = "Python <-> Objective-C bridge";
    homepage = "https://github.com/ronaldoussoren/pyobjc/tree/main/pyobjc-core";
    license = lib.licenses.mit;
    platforms = lib.platforms.darwin;
    maintainers = with lib.maintainers; [ samuela ];
  };
}
