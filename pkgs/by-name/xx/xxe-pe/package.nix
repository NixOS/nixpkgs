{
  stdenv,
  fetchurl,
  lib,
  unzip,
  makeWrapper,
  openjdk11,
  makeDesktopItem,
  icoutils,
  config,
  acceptLicense ? config.xxe-pe.acceptLicense or false,
}:

let
  pkg_path = "$out/lib/xxe";

  desktopItem = makeDesktopItem {
    name = "XMLmind XML Editor Personal Edition";
    exec = "xxe";
    icon = "xxe";
    desktopName = "xxe";
    genericName = "XML Editor";
    categories = [
      "Development"
      "IDE"
      "TextEditor"
      "Java"
    ];
  };
in
stdenv.mkDerivation rec {
  pname = "xxe-pe";
  version = "10.2.0";

  src =
    assert
      !acceptLicense
      -> throw ''
        You must accept the XMLmind XML Editor Personal Edition License at
        https://www.xmlmind.com/xmleditor/license_xxe_perso.html
        by setting nixpkgs config option `xxe-pe.acceptLicense = true;`
        or by using `xxe-pe.override { acceptLicense = true; }` package.
      '';
    fetchurl {
      url = "https://www.xmlmind.com/xmleditor/_download/xxe-perso-${
        builtins.replaceStrings [ "." ] [ "_" ] version
      }.zip";
      sha256 = "sha256-JZ9nQwMrQL/1HKGwvXoWlnTx55ZK/UYjMJAddCtm0rw=";
    };

  nativeBuildInputs = [
    unzip
    makeWrapper
    icoutils
  ];

  dontStrip = true;

  installPhase = ''
    mkdir -p "${pkg_path}"
    mkdir -p "${pkg_path}" "$out/share/applications"
    cp -a * "${pkg_path}"
    ln -s ${desktopItem}/share/applications/* $out/share/applications

    icotool -x "${pkg_path}/bin/icon/xxe.ico"
    ls
    for f in xxe_*.png; do
      res=$(basename "$f" ".png" | cut -d"_" -f3 | cut -d"x" -f1-2)
      mkdir -pv "$out/share/icons/hicolor/$res/apps"
      mv "$f" "$out/share/icons/hicolor/$res/apps/xxe.png"
    done;
  '';

  postFixup = ''
    mkdir -p "$out/bin"
    makeWrapper "${pkg_path}/bin/xxe" "$out/bin/xxe" \
      --prefix PATH : ${lib.makeBinPath [ openjdk11 ]}
  '';

  meta = with lib; {
    description = "Strictly validating, near WYSIWYG, XML editor with DocBook support";
    homepage = "https://www.xmlmind.com/xmleditor/";
    license = licenses.unfree;
    maintainers = [ ];
    platforms = [ "x86_64-linux" ];
  };
}
