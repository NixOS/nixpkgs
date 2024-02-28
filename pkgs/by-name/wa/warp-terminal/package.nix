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
, xdg-utils
, xorg
, zlib
}:

let
pname = "warp-terminal";
version = "0.2024.02.20.08.01.stable_01";

linux = stdenv.mkDerivation (finalAttrs:  {
  inherit pname version meta;
  src = fetchurl {
    url = "https://releases.warp.dev/stable/v${finalAttrs.version}/warp-terminal-v${finalAttrs.version}-1-x86_64.pkg.tar.zst";
    hash = "sha256-L8alnqSE4crrDozRfPaAAMkLc+5+8d9XBKd5ddsxmD0=";
  };

  sourceRoot = ".";

  postPatch = ''
    substituteInPlace usr/bin/warp-terminal \
      --replace-fail /opt/ $out/opt/
  '';

  nativeBuildInputs = [ autoPatchelfHook zstd ];

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
  ];

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -r opt usr/* $out

    runHook postInstall
  '';
});

darwin = stdenvNoCC.mkDerivation (finalAttrs: {
  inherit pname version meta;
  src = fetchurl {
    url = "https://releases.warp.dev/stable/v${finalAttrs.version}/Warp.dmg";
    hash = "sha256-tFtoD8URMFfJ3HRkyKStuDStFkoRIV97y9kV4pbDPro=";
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
  maintainers = with maintainers; [ emilytrau Enzime ];
  platforms = platforms.darwin ++ [ "x86_64-linux" ];
};

in
if stdenvNoCC.isDarwin
then darwin
else linux
