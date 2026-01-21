{
  buildPythonPackage,
  darwin,
  fetchFromGitHub,
  lib,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyobjc-core";
  version = "12.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ronaldoussoren";
    repo = "pyobjc";
    tag = "v${version}";
    hash = "sha256-mKrn8p6zP53sGCpFjBEWqGNx5MVXcE9x9nlTrzTdPBM=";
  };

  sourceRoot = "${src.name}/pyobjc-core";

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
}
