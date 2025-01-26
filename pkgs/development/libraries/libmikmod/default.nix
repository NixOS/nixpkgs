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
  version = "3.3.12";

  src = fetchurl {
    url = "mirror://sourceforge/mikmod/libmikmod-${version}.tar.gz";
    sha256 = "sha256-re9iFIY1FqSltE6/LHHvhOzf6zRElz2suscJEcm8Z+k=";
  };

  buildInputs =
    [ texinfo ]
    ++ optional stdenv.hostPlatform.isLinux alsa-lib
    ++ optional stdenv.hostPlatform.isDarwin CoreAudio;
  propagatedBuildInputs = optional stdenv.hostPlatform.isLinux libpulseaudio;

  outputs = [
    "out"
    "dev"
    "man"
  ];

  NIX_LDFLAGS = optionalString stdenv.hostPlatform.isLinux "-lasound";

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
