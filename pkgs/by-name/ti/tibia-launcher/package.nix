{
  requireFile,
  stdenv,
  appimageTools,
  buildFHSEnv,
  libxml2,
  fetchurl,
  lib,
  makeDesktopItem,
  copyDesktopItems,
  pkgs,
}:

let
  pname = "tibia-launcher";
  version = "15.11.34ee73";

  # TODO: find appropriate flags for curl to avoid getting 403'd The following
  # curl invocation seems to work locally just fine, but doesn't play nicely
  # with fetchurl
  #
  # curl -L -H "Accept: */*" -H "Accept-Encoding: identity" -H "Connection: Keep-Alive" \
  #   http://static.tibia.com/download/tibia.x64.tar.gz -o tibia.tar.gz
  src = requireFile {
    name = "tibia.x64.tar.gz";
    url = "https://www.tibia.com/account/?subtopic=downloadclient";
    sha256 = "cd159f932c29cab647c7f02f967f7a766ea0e65bf13878da3e8adcaba6cb5250";
  };

  # libxml2.so.2 error hack
  libxml2_13 = libxml2.overrideAttrs rec {
    version = "2.13.8";
    src = fetchurl {
      url = "mirror://gnome/sources/libxml2/${lib.versions.majorMinor version}/libxml2-${version}.tar.xz";
      hash = "sha256-J3KUyzMRmrcbK8gfL0Rem8lDW4k60VuyzSsOhZoO6Eo=";
    };
  };

in

stdenv.mkDerivation rec {
  inherit pname version src;

  nativeBuildInputs = with pkgs; [
    copyDesktopItems
    iconConvTools
    imagemagick
  ];

  fhsEnv = buildFHSEnv (
    appimageTools.defaultFhsEnvArgs
    // {
      name = "${pname}-fhs";

      targetPkgs =
        pkgs:
        (with pkgs; [
          libevent
          libxml2_13
          libxkbcommon
          libxslt
          xorg.libxkbfile
        ]);
    }
  );

  installPhase = ''
    icoFileToHiColorTheme tibia.ico tibia $out

    mkdir -p $out/bin
    cp -r * $out/bin
    mv $out/bin/Tibia $out/bin/${pname}

    echo "${fhsEnv}/bin/${fhsEnv.name} -c \"$out/bin/${pname}\"" > $out/bin/Tibia
    chmod +x $out/bin/Tibia

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      desktopName = "Tibia";
      name = pname;
      exec = "Tibia";
      icon = "tibia";
      categories = [ "Game" ];
    })
  ];

  meta = with lib; {
    description = "Multiplayer Online Role Playing Game";
    homepage = "https://www.tibia.com";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [
      fkokosinski
    ];
  };
}
