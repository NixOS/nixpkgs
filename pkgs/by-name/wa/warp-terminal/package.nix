{ lib
, stdenvNoCC
, stdenv
, fetchurl
, autoPatchelfHook
, undmg
, zstd
, curl
, fontconfig
, libglvnd
, libxkbcommon
, vulkan-loader
, wayland
, xdg-utils
, xorg
, zlib
, makeWrapper
, waylandSupport ? false
}:

let
pname = "warp-terminal";
versions = lib.importJSON ./versions.json;
passthru.updateScript = ./update.sh;

linux_arch =
  if stdenv.hostPlatform.system == "x86_64-linux"
    then "x86_64"
    else "aarch64";

linux = stdenv.mkDerivation (finalAttrs:  {
  inherit pname meta passthru;
  inherit (versions."linux_${linux_arch}") version;
  src = fetchurl {
    inherit (versions."linux_${linux_arch}") hash;
    url = "https://releases.warp.dev/stable/v${finalAttrs.version}/warp-terminal-v${finalAttrs.version}-1-${linux_arch}.pkg.tar.zst";
  };

  sourceRoot = ".";

  postPatch = ''
    substituteInPlace usr/bin/warp-terminal \
      --replace-fail /opt/ $out/opt/
  '';

  nativeBuildInputs = [ autoPatchelfHook zstd makeWrapper ];

  buildInputs = [
    curl
    fontconfig
    stdenv.cc.cc.lib # libstdc++.so libgcc_s.so
    zlib
  ];

  runtimeDependencies = [
    libglvnd # for libegl
    libxkbcommon
    stdenv.cc.libc
    vulkan-loader
    xdg-utils
    xorg.libX11
    xorg.libxcb
    xorg.libXcursor
    xorg.libXi
  ] ++ lib.optionals waylandSupport [wayland];

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -r opt usr/* $out

  '' + lib.optionalString waylandSupport ''
    wrapProgram $out/bin/warp-terminal --set WARP_ENABLE_WAYLAND 1
  '' + ''
    runHook postInstall
  '';
});

darwin = stdenvNoCC.mkDerivation (finalAttrs: {
  inherit pname meta passthru;
  inherit (versions.darwin) version;
  src = fetchurl {
    inherit (versions.darwin) hash;
    url = "https://releases.warp.dev/stable/v${finalAttrs.version}/Warp.dmg";
  };

  sourceRoot = ".";

  nativeBuildInputs = [ undmg ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r *.app $out/Applications

    runHook postInstall
  '';
});

meta = with lib; {
  description = "Rust-based terminal";
  homepage = "https://www.warp.dev";
  license = licenses.unfree;
  sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  maintainers = with maintainers; [ emilytrau imadnyc donteatoreo johnrtitor ];
  platforms = platforms.darwin ++ [ "x86_64-linux" "aarch64-linux" ];
};

in
if stdenvNoCC.hostPlatform.isDarwin
then darwin
else linux
