{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  libcdio,
  pkg-config,
  libiconv,
  IOKit,
  DiskArbitration,
}:

stdenv.mkDerivation rec {
  pname = "libcdio-paranoia";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "rocky";
    repo = "libcdio-paranoia";
    rev = "release-10.2+${version}";
    hash = "sha256-n05PSVgh6z7BFPq4CjJa5DqCO7Huj8Bsg0x3HQPsbeI=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs =
    [ libcdio ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      libiconv
      IOKit
      DiskArbitration
    ];

  propagatedBuildInputs = lib.optional stdenv.hostPlatform.isDarwin DiskArbitration;

  configureFlags = lib.optionals stdenv.hostPlatform.isDarwin [ "--disable-ld-version-script" ];

  meta = with lib; {
    description = "CD paranoia on top of libcdio";
    longDescription = ''
      This is a port of xiph.org's cdda paranoia to use libcdio for CDROM
      access. By doing this, cdparanoia runs on platforms other than GNU/Linux.
    '';
    homepage = "https://github.com/rocky/libcdio-paranoia";
    license = licenses.gpl3;
    maintainers = [ ];
    mainProgram = "cd-paranoia";
    platforms = platforms.unix;
  };
}
