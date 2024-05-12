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

linux = stdenv.mkDerivation (finalAttrs:  {
  inherit pname meta passthru;
  inherit (versions.linux) version;
  src = fetchurl {
    inherit (versions.linux) hash;
    url = "https://releases.warp.dev/stable/v${finalAttrs.version}/warp-terminal-v${finalAttrs.version}-1-x86_64.pkg.tar.zst";
  };

  sourceRoot = ".";

  postPatch = ''
    substituteInPlace usr/bin/warp-terminal \
      --replace /opt/ $out/opt/
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
  maintainers = with maintainers; [ emilytrau Enzime imadnyc donteatoreo ];
  platforms = platforms.darwin ++ [ "x86_64-linux" ];
};

in
if stdenvNoCC.isDarwin
then darwin
else linux
