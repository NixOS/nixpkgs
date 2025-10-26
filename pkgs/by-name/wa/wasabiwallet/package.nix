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
  version = "2.7.1";

  src = fetchurl {
    url = "https://github.com/WalletWasabi/WalletWasabi/releases/download/v${version}/Wasabi-${version}-linux-x64.tar.gz";
    sha256 = "sha256-o2e2NDG2aMrEYc/7x5iFex9oRlrQXeKIINuW80ZwWcI=";
  };

  dontBuild = true;

  desktopItem = makeDesktopItem {
    name = "wasabi";
    exec = "wasabiwallet-desktop";
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

    # The weird path is an upstream packaging error and could be fixed in the upcoming release
    cp -Rv ./runner/work/WalletWasabi/WalletWasabi/build/linux-x64/* $out/opt/${pname}

    for nameMap in "wassabee:desktop" "wassabeed:daemon" "wcoordinator:coordinator" "wbackend:backend"; do
      IFS=":" read -r filename wrappedname <<< "$nameMap"
      makeWrapper "$out/opt/${pname}/$filename" "$out/bin/${pname}-$wrappedname" \
        --suffix "LD_LIBRARY_PATH" : "${lib.makeLibraryPath runtimeLibs}"
    done

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
