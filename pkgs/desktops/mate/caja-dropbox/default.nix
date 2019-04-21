{ stdenv, fetchurl, pkgconfig, gtk3, mate, python3Packages }:

stdenv.mkDerivation rec {
  name = "caja-dropbox-${version}";
  version = "1.22.0";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "1bnvqybsfrfxxvfchvpki77hg6r9vbpq0h80smc47rks5hzj6lyi";
  };

  nativeBuildInputs = [
    pkgconfig
  ];

  buildInputs = [
    gtk3
    mate.caja
    python3Packages.python
    python3Packages.pygtk
    python3Packages.docutils
  ];

  configureFlags = [ "--with-caja-extension-dir=$$out/lib/caja/extensions-2.0" ];

  meta = with stdenv.lib; {
    description = "Dropbox extension for Caja file manager";
    homepage = https://github.com/mate-desktop/caja-dropbox;
    license = with licenses; [ gpl3 cc-by-nd-30 ];
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
