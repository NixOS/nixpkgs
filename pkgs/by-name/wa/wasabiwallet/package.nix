{
  lib,
  stdenv,
  autoPatchelfHook,
  makeWrapper,
  fetchurl,
  makeDesktopItem,
  lttng-ust_2_12,
  fontconfig,
  openssl,
  xorg,
  zlib,
}:

let
  # These libraries are dynamically loaded by the application,
  # and need to be present in LD_LIBRARY_PATH
  runtimeLibs = [
    fontconfig.lib
    openssl
    (lib.getLib stdenv.cc.cc)
    xorg.libX11
    xorg.libICE
    xorg.libSM
    zlib
  ];
in
stdenv.mkDerivation rec {
  pname = "wasabiwallet";
  version = "2.0.8.1";

  src = fetchurl {
    url = "https://github.com/zkSNACKs/WalletWasabi/releases/download/v${version}/Wasabi-${version}.tar.gz";
    sha256 = "sha256-9q93C8Q4MKrpvAs6cb4sgo3PDVhk9ZExeHIZ9Qm8P2w=";
  };

  dontBuild = true;

  desktopItem = makeDesktopItem {
    name = "wasabi";
    exec = "wasabiwallet";
    desktopName = "Wasabi";
    genericName = "Bitcoin wallet";
    comment = meta.description;
    categories = [
      "Network"
      "Utility"
    ];
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];
  buildInputs = runtimeLibs ++ [
    lttng-ust_2_12
  ];

  installPhase = ''
    mkdir -p $out/opt/${pname} $out/bin $out/share/applications
    cp -Rv . $out/opt/${pname}

    makeWrapper "$out/opt/${pname}/wassabee" "$out/bin/${pname}" \
      --suffix "LD_LIBRARY_PATH" : "${lib.makeLibraryPath runtimeLibs}"

    makeWrapper "$out/opt/${pname}/wassabeed" "$out/bin/${pname}d" \
      --suffix "LD_LIBRARY_PATH" : "${lib.makeLibraryPath runtimeLibs}"

    cp -v $desktopItem/share/applications/* $out/share/applications
  '';

  meta = with lib; {
    description = "Privacy focused Bitcoin wallet";
    homepage = "https://wasabiwallet.io/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ mmahut ];
  };
}
