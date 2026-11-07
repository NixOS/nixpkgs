{
  buildPythonPackage,
  darwin,
  fetchFromGitHub,
  lib,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyobjc-core";
  version = "12.2.2";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ronaldoussoren";
    repo = "pyobjc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jtThPYaKWtIUzcaWxg34QxZc2ejCnSulwsjEUiTfb2Y=";
  };

  sourceRoot = "${finalAttrs.src.name}/pyobjc-core";

  build-system = [ setuptools ];

  buildInputs = [
    darwin.libffi
  ];

  nativeBuildInputs = [
    darwin.DarwinTools # sw_vers
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    "-I${darwin.libffi.dev}/include"
    "-Wno-error=cast-function-type-mismatch"
    "-Wno-error=unused-command-line-argument"
  ];

  pythonImportsCheck = [ "objc" ];

  meta = {
    description = "Python <-> Objective-C bridge";
    homepage = "https://github.com/ronaldoussoren/pyobjc/tree/main/pyobjc-core";
    license = lib.licenses.mit;
    platforms = lib.platforms.darwin;
    maintainers = with lib.maintainers; [ samuela ];
  };
})
