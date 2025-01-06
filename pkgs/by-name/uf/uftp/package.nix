{
  lib,
  stdenv,
  fetchurl,
  openssl,
}:

stdenv.mkDerivation rec {
  pname = "uftp";
  version = "5.0.3";

  src = fetchurl {
    url = "mirror://sourceforge/uftp-multicast/source-tar/uftp-${version}.tar.gz";
    sha256 = "sha256-y4ZowZsfELxjoW/6iT4gXcPshjYQN9R32AAyYOvEAIA=";
  };

  buildInputs = [ openssl ];

  outputs = [
    "out"
    "man"
  ];

  patchPhase = ''
    substituteInPlace makefile --replace gcc cc
  '';

  installPhase = ''
    mkdir -p $out/bin $man/share/man/man1
    cp {uftp,uftpd,uftp_keymgt,uftpproxyd} $out/bin/
    cp {uftp.1,uftpd.1,uftp_keymgt.1,uftpproxyd.1} $man/share/man/man1
  '';

  meta = {
    description = "Encrypted UDP based FTP with multicast";
    homepage = "https://uftp-multicast.sourceforge.net/";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.fadenb ];
    platforms = with lib.platforms; linux ++ darwin;
  };
}
