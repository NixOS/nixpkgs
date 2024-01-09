{ lib
, stdenvNoCC
, fetchurl
, makeWrapper
, undmg
, appimageTools
, autoPatchelfHook
, wayland
, libGL
, libz
, e2fsprogs
, gmp
, p11-kit
, libX11
, libXcursor
, libXi
, libxkbcommon
, vulkan-loader
, channel ? "stable"
}:
let
  versions = {
    stable = "0.2024.01.02.08.02.stable_02";
    beta = "0.2024.01.09.08.02.beta_00";
    preview = "0.2024.01.09.17.38.preview_00";
    dev = "0.2024.01.09.17.38.dev_00";
  };
  platformSuffixes = {
    darwin = ".dmg";
    linux = "-x86_64.AppImage";
  };
  strTitleCase = str: with builtins; "${lib.strings.toUpper (substring 0 1 str)}${substring 1 (stringLength str) str}";
  mkSrc = channel: platform: sha256: fetchurl {
    inherit sha256;
    url = "https://releases.warp.dev/${channel}/v${versions."${channel}"}/Warp${if channel == "stable" then "" else strTitleCase channel}${platformSuffixes."${platform}"}";
  };
  sources = {
    linux = {
      stable = mkSrc "stable" "linux" "sha256-olHiGdd09x5qnHpEp1RPbai2nnH1eFZfQs59+A3UC6Y=";
      beta = mkSrc "beta" "linux" "sha256-IkX7yQAHCaiLzBYbkbZjuy+DyZ8937Ku5Wds92wc5RQ=";
      # preview = mkSrc "preview" "linux" ""; # seems like there are no preview channel builds for Linux
      dev = mkSrc "dev" "linux" "sha256-kXunWBTpswsFVo9u+bbpLC6TgqI28jnVk7EHDDXBbhI=";
    };
    darwin = {
      stable = mkSrc "stable" "darwin" "sha256-ayJQI8Ui2wPS0RZLQMnnNDPcAw+3f4XrOztpg0JrXh0=";
      beta = mkSrc "beta" "darwin" "sha256-g1ymediQizYZRVcqybaHv9uFqM+T1xPfkUuLdVMR6J0=";
      preview = mkSrc "preview" "darwin" "sha256-sFxk2hzS+32Nnr6xtYfv2c0uzf2mYzVWaV6H4rhdOfQ=";
      dev = mkSrc "dev" "darwin" "sha256-kPAf3MuJ14BIhMk3Goh/CutKmGpIf3o61eJ7OSVU+h8=";
    };
  };

  pname = "warp-terminal";
  version = versions."${channel}";
  meta = with lib; {
    description = "Rust-based terminal";
    homepage = "https://www.warp.dev";
    license = licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ emilytrau Enzime ];
    platforms = platforms.darwin ++ (if channel != "preview" then [ "x86_64-linux" ] else []);
  };
in stdenvNoCC.mkDerivation (if stdenvNoCC.isLinux then {
  inherit pname version;

  src = appimageTools.extract {
    inherit pname version;
    src = sources.linux."${channel}";
  };

  nativeBuildInputs = [ makeWrapper autoPatchelfHook ];
  buildInputs = [ libz e2fsprogs gmp p11-kit ];
  runtimeDependencies = [ libX11 libXcursor libXi libxkbcommon vulkan-loader wayland libGL ];

  installPhase = ''
    install -m 444 -D usr/share/applications/dev.warp.Warp*.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/dev.warp.Warp*.desktop \
      --replace 'Exec=${channel} %U' 'Exec=warp-term %U'
    install -m 444 -D usr/share/icons/hicolor/512x512/apps/dev.warp.Warp*.png \
      -t $out/share/icons/hicolor/512x512/apps

    install -m 755 -D usr/bin/${channel} $out/bin/warp-term${if channel == "stable" then "" else "-${channel}"}
    install -D usr/lib/* -t $out/lib

    wrapProgram $out/bin/warp-term* --set WARP_ENABLE_WAYLAND 1
  '';

  inherit meta;
} else (finalAttrs: {
  inherit pname version;

  src = sources.darwin."${channel}";

  sourceRoot = ".";

  nativeBuildInputs = [ undmg ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r *.app $out/Applications

    runHook postInstall
  '';

  inherit meta;
}))
