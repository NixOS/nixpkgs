{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,

  maturin,
  protobuf_30,
}:
buildPythonPackage (finalAttrs: {
  pname = "pyluwen";
  version = "0.9.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tenstorrent";
    repo = "luwen";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pc/7G9YxBTg2uYn47ONxI7zsfdK3Ex4zndLASRtDQyk=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-2ibAZnfv++eyCB57F0uD7XFJ3MP9SnAApOn6uelo3Po=";
  };

  sourceRoot = "${finalAttrs.src.name}/bind/pyluwen";

  prePatch = ''
    chmod -R u+w ../../
    cd ../../
  '';

  postPatch = ''
    cd ../$sourceRoot
    cp --no-preserve=ownership,mode ../../Cargo.lock .
    sed -i '0,/version = /{s/version = "*.*.*"/version = "${finalAttrs.version}"/g}' Cargo.toml
  '';

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
    protobuf_30
  ];

  build-system = [ maturin ];

  meta = {
    description = "Tenstorrent system interface library";
    homepage = "https://github.com/tenstorrent/luwen";
    changelog = "https://github.com/tenstorrent/luwen/releases/tag/${finalAttrs.src.tag}";
    maintainers = with lib.maintainers; [ RossComputerGuy ];
    license = lib.licenses.asl20;
  };
})
