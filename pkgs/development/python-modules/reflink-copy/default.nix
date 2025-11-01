{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "reflink-copy";
  version = "0.3.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "iterative";
    repo = "reflink-copy";
    tag = version;
    hash = "sha256-HxUAsqV5kjstfBfY/nEGJ3epUVT5WXoTqKerUggKDyo=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-TBKVf0kRRYn+1aYvhQHCHmJEsT0khFxp8iuyEWX9xyI=";
  };

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "reflink_copy" ];

  meta = with lib; {
    description = "Python wrapper for reflink_copy Rust library";
    homepage = "https://github.com/iterative/reflink-copy";
    license = licenses.asl20;
    maintainers = with maintainers; [ ambroisie ];
  };
}
