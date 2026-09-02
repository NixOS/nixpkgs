{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "reflink-copy";
  version = "0.3.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "iterative";
    repo = "reflink-copy";
    tag = finalAttrs.version;
    hash = "sha256-HxUAsqV5kjstfBfY/nEGJ3epUVT5WXoTqKerUggKDyo=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-TBKVf0kRRYn+1aYvhQHCHmJEsT0khFxp8iuyEWX9xyI=";
  };

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "reflink_copy" ];

  meta = {
    description = "Python wrapper for reflink_copy Rust library";
    homepage = "https://github.com/iterative/reflink-copy";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ambroisie ];
  };
})
