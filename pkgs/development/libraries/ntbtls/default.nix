{ lib, stdenv, fetchurl, gettext, libgpg-error, libgcrypt, libksba, zlib }:

stdenv.mkDerivation rec {
  pname = "ntbtls";
  version = "0.3.2";

  src = fetchurl {
    url = "mirror://gnupg/ntbtls/ntbtls-${version}.tar.bz2";
    sha256 = "sha256-vfy5kCSs7JxsS5mK1juzkh30z+5KdyrWwMoyTbvysHw=";
  };

  outputs = [ "dev" "out" ];

  buildInputs = [ libgcrypt libgpg-error libksba zlib ]
    ++ lib.optional stdenv.hostPlatform.isDarwin gettext;

  postInstall = ''
    moveToOutput "bin/ntbtls-config" $dev
  '';

  meta = with lib; {
    description = "Tiny TLS 1.2 only implementation";
    mainProgram = "ntbtls-config";
    homepage = "https://www.gnupg.org/software/ntbtls/";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ joachifm ];
  };
}
