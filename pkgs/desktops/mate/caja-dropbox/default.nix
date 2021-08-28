{ lib, stdenv, fetchurl, substituteAll
, pkg-config, gobject-introspection, gdk-pixbuf
, gtk3, mate, python3, dropbox, mateUpdateScript }:

let
  dropboxd = "${dropbox}/bin/dropbox";
in
stdenv.mkDerivation rec {
  pname = "caja-dropbox";
  version = "1.24.0";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1rcn82q58mv9hn5xamvzay2pw1szfk6zns94362476fcp786lji2";
  };

  patches = [
    (substituteAll {
      src = ./fix-cli-paths.patch;
      inherit dropboxd;
    })
  ];

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    gobject-introspection
    gdk-pixbuf
    (python3.withPackages (ps: with ps; [
      docutils
      pygobject3
    ]))
  ];

  buildInputs = [
    gtk3
    mate.caja
    python3
  ];

  configureFlags = [ "--with-caja-extension-dir=$$out/lib/caja/extensions-2.0" ];

  enableParallelBuilding = true;

  passthru.updateScript = mateUpdateScript { inherit pname version; };

  meta = with lib; {
    description = "Dropbox extension for Caja file manager";
    homepage = "https://github.com/mate-desktop/caja-dropbox";
    license = with licenses; [ gpl3Plus cc-by-nd-30 ];
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
