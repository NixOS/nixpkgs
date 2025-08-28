{
  _cuda,
  fetchzip,
  lib,
  stdenv,
}:
let
  inherit (lib) maintainers teams;
  inherit (lib.strings) concatStringsSep;
  inherit (lib.trivial) mapNullable;
  baseURL = "https://developer.download.nvidia.com/compute/cublasdx/redist/cublasdx";
in
# NOTE(@connorbaker): The docs are a large portion of headers tarball. They're also duplicated in
# include/{cublasdx,cufftdx}/docs.
# TODO: They vendor a copy of cutlass in the zip under external...
# headers = fetchzip {
#   name = "nvidia-mathdx-24.08.0";
#   url = "${baseURL}/nvidia-mathdx-24.08.0.tar.gz";
#   hash = "sha256-nSzDzjSH8yfL0r67AbwJ47aBz59Ib4e/sgyNtI7zg4M=";
# };
stdenv.mkDerivation (finalAttrs: {
  __structuredAttrs = true;
  strictDeps = true;

  # NOTE: Does not depend on the CUDA package set, so do not use cudaNamePrefix to avoid causing
  # unnecessary / duplicate store paths.
  pname = "libmathdx";
  version = "0.1.2";

  src =
    let
      name = concatStringsSep "-" [
        finalAttrs.pname
        "Linux"
        stdenv.hostPlatform.parsed.cpu.name
        finalAttrs.version
      ];
      hashes = {
        aarch64-linux = "sha256-CTf1Unt+QBYZ+OsypQU0ppf4ucsEaFMaro9srvlnt1Y=";
        x86_64-linux = "sha256-wD23ppuVCDUkmPVpZPoHa/miYGTF22YUiO8wCBqj1OY=";
      };
    in
    mapNullable (
      hash:
      fetchzip {
        inherit hash name;
        url = "${baseURL}/${name}.tar.gz";
      }
    ) (hashes.${stdenv.hostPlatform.system} or null);

  # Everything else should be kept in the same output. While there are some shared libraries, I'm not familiar enough
  # with the project to know how they're used or if it's safe to split them out/change the directory structures.
  outputs = [
    "out"
    "static"
  ];

  preInstall = ''
    mkdir -p "$out"
    mv * "$out"
    mkdir -p "$static"
    moveToOutput "lib/libmathdx_static.a" "$static"
  '';

  doCheck = false;

  meta = {
    description = "A library used to integrate cuBLASDx and cuFFTDx into Warp";
    homepage = "https://developer.nvidia.com/cublasdx-downloads";
    license = _cuda.lib.licenses.math_sdk_sla;
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    maintainers = [ maintainers.connorbaker ];
    teams = [ teams.cuda ];
  };
})
