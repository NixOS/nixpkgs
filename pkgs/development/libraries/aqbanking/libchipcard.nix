{ stdenv, fetchurl, pkgconfig, gwenhywfar, pcsclite, zlib }:

let
  inherit ((import ./sources.nix).libchipcard) sha256 releaseId version;
in stdenv.mkDerivation rec {
  pname = "libchipcard";
  inherit version;

  src = fetchurl {
    url = "https://www.aquamaniac.de/rdm/attachments/download/${releaseId}/${pname}-${version}.tar.gz";
    inherit sha256;
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
