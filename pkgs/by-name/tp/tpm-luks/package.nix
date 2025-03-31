{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  gawk,
  trousers,
  cryptsetup,
  openssl,
}:

stdenv.mkDerivation {
  pname = "tpm-luks";
  version = "unstable-2015-07-11";

  src = fetchFromGitHub {
    owner = "momiji";
    repo = "tpm-luks";
    rev = "c9c5b7fdddbcdac1cd4d2ea6baddd0617cc88ffa";
    sha256 = "sha256-HHyZLZAXfmuimpHV8fOWldZmi4I5uV1NnSmP4E7ZQtc=";
  };

  patches = [
    ./openssl-1.1.patch
    ./signed-ptr.patch
  ];

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [
    gawk
    trousers
    cryptsetup
    openssl
  ];

  installPhase = ''
    mkdir -p $out
    make install DESTDIR=$out
    mv $out/$out/sbin $out/bin
    rm -r $out/nix
  '';

  meta = with lib; {
    description = "LUKS key storage in TPM NVRAM";
    homepage = "https://github.com/shpedoikal/tpm-luks/";
    maintainers = [ ];
    license = with licenses; [ gpl2Only ];
    platforms = platforms.linux;
  };
}
