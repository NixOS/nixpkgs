{ lib, stdenv, fetchurl, pkg-config, gwenhywfar, pcsclite, zlib }:

let
  inherit ((import ./sources.nix).libchipcard) hash releaseId version;
in stdenv.mkDerivation rec {
  pname = "libchipcard";
  inherit version;

  src = fetchurl {
    url = "https://www.aquamaniac.de/rdm/attachments/download/${releaseId}/${pname}-${version}.tar.gz";
    inherit hash;
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ gwenhywfar pcsclite zlib ];

  makeFlags = [ "crypttokenplugindir=$(out)/lib/gwenhywfar/plugins/ct" ];

  meta = with lib; {
    description = "Library for access to chipcards";
    homepage = "https://www.aquamaniac.de/rdm/projects/libchipcard";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ aszlig ];
    platforms = platforms.linux;
  };
}
