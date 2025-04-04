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
  version = "2.5.1";

  src = fetchurl {
    url = "https://github.com/zkSNACKs/WalletWasabi/releases/download/v${version}/Wasabi-${version}-linux-x64.tar.gz";
    sha256 = "sha256-DTgxLg8NwjHX085Ai6zxXgjL3x8ZHqVIpvxk/KRl+7w=";
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
    cp -Rv ./runner/work/WalletWasabi/WalletWasabi/build/linux-x64/* $out/opt/${pname}

    makeWrapper "$out/opt/${pname}/wassabee" "$out/bin/${pname}-desktop" \
      --suffix "LD_LIBRARY_PATH" : "${lib.makeLibraryPath runtimeLibs}"

    makeWrapper "$out/opt/${pname}/wassabeed" "$out/bin/${pname}-daemon" \
      --suffix "LD_LIBRARY_PATH" : "${lib.makeLibraryPath runtimeLibs}"

    makeWrapper "$out/opt/${pname}/wcoordinator" "$out/bin/${pname}-coordinator" \
      --suffix "LD_LIBRARY_PATH" : "${lib.makeLibraryPath runtimeLibs}"

    makeWrapper "$out/opt/${pname}/wbackend" "$out/bin/${pname}-backend" \
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
