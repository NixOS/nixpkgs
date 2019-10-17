{ stdenv, fetchurl, pkgconfig, gwenhywfar, pcsclite, zlib }:


stdenv.mkDerivation rec {
  pname = "libchipcard";
  version = "5.0.4";

  src = fetchurl {
    url = https://www.aquamaniac.de/rdm/attachments/download/158/libchipcard-5.0.4.tar.gz;
    sha256 = "0fj2h39ll4kiv28ch8qgzdbdbnzs8gl812qnm660bw89rynpjnnj";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ gwenhywfar pcsclite zlib ];

  makeFlags = [ "crypttokenplugindir=$(out)/lib/gwenhywfar/plugins/ct" ];

  configureFlags = [ "--with-gwen-dir=${gwenhywfar}" ];

  meta = with stdenv.lib; {
    description = "Library for access to chipcards";
    homepage = "https://www.aquamaniac.de/rdm/projects/libchipcard";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ aszlig ];
    platforms = platforms.linux;
  };
}
