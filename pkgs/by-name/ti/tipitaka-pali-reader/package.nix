{ appimageTools, fetchurl, lib, libXdmcp, libXtst }:

let
  pname = "tipitaka-pali-reader";
  version = "2.6.1+72";
  src = fetchurl {
    url = "https://github.com/bksubhuti/tipitaka-pali-reader/releases/download/v2.6.1%2B72/tipitaka_pali_reader.AppImage";
    name = "${version}-tipitaka_pali_reader.AppImage";
    sha256 = "U8hu9mk0tezF/S4GqYFLTK1KvvvangiExMT84b0TsL4=";
  };

  appimageContents = appimageTools.extractType2 { inherit pname version src; };

in
appimageTools.wrapType2 {

  inherit pname version src;

  extraPkgs = pkgs: with pkgs; [

    libXdmcp
    libXtst
    libdatrie
    libepoxy
    libselinux
    libsepol
    libthai
    libxkbcommon
    sqlite

  ];

  extraInstallCommands = ''

    install -m 444 -D ${appimageContents}/tipitaka_pali_reader.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/tipitaka_pali_reader.desktop \
      --replace-warn 'Exec=tipitaka_pali_reader' 'Exec=${pname}'

    cp -r ${appimageContents}/logo.png $out/share

    mkdir -p $out/etc/udev/rules.d

    echo 'KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0666", TAG+="uaccess", TAG+="udev-acl"' > $out/etc/udev/rules.d/92-viia.rules

  '';

  meta = with lib; {
    description = "Reader with built-in dictionary for the Theravāda Buddhist Tipitaka";
    homepage = "https://americanmonk.org/tipitaka-pali-reader/";
    license = licenses.gpl3;
    mainProgram = "tipitaka-pali-reader";
  };
}
