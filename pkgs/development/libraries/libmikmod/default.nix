{
  lib,
  stdenv,
  fetchurl,
  texinfo,
  alsa-lib,
  libpulseaudio,
  CoreAudio,
}:

let
  inherit (lib) optional optionalString;

in
stdenv.mkDerivation rec {
  pname = "libmikmod";
  version = "3.3.11.1";

  src = fetchurl {
    url = "mirror://sourceforge/mikmod/libmikmod-${version}.tar.gz";
    sha256 = "06bdnhb0l81srdzg6gn2v2ydhhaazza7rshrcj3q8dpqr3gn97dd";
  };

  buildInputs = [ texinfo ] ++ optional stdenv.isLinux alsa-lib ++ optional stdenv.isDarwin CoreAudio;
  propagatedBuildInputs = optional stdenv.isLinux libpulseaudio;

  outputs = [
    "out"
    "dev"
    "man"
  ];

  NIX_LDFLAGS = optionalString stdenv.isLinux "-lasound";

  postInstall = ''
    moveToOutput bin/libmikmod-config "$dev"
  '';

  meta = with lib; {
    description = "Library for playing tracker music module files";
    mainProgram = "libmikmod-config";
    homepage = "https://mikmod.shlomifish.org/";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [
      astsmtl
      lovek323
    ];
    platforms = platforms.unix;

    longDescription = ''
      A library for playing tracker music module files supporting many formats,
      including MOD, S3M, IT and XM.
    '';
  };
}
