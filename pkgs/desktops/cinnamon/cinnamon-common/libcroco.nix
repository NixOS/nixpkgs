{ lib, stdenv, fetchurl, pkg-config, libxml2, glib, gnome3 }:

stdenv.mkDerivation rec {
  pname = "libcroco";
  version = "0.6.13";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1m110rbj5d2raxcdp4iz0qp172284945awrsbdlq99ksmqsc4zkn";
  };

  outputs = [ "out" "dev" ];
  outputBin = "dev";

  configureFlags = lib.optional stdenv.isDarwin "--disable-Bsymbolic";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libxml2 glib ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with lib; {
    description = "GNOME CSS2 parsing and manipulation toolkit";
    homepage = https://gitlab.gnome.org/GNOME/libcroco;
    license = licenses.lgpl2;
    platforms = platforms.unix;
  };
}

