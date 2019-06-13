{ stdenv, fetchurl, texinfo, alsaLib, libpulseaudio, CoreAudio }:

let
  inherit (stdenv.lib) optional optionals optionalString;

in stdenv.mkDerivation rec {
  name = "libmikmod-3.3.11.1";
  src = fetchurl {
    url = "mirror://sourceforge/mikmod/${name}.tar.gz";
    sha256 = "06bdnhb0l81srdzg6gn2v2ydhhaazza7rshrcj3q8dpqr3gn97dd";
  };

  buildInputs = [ texinfo ]
    ++ optional stdenv.isLinux alsaLib
    ++ optional stdenv.isDarwin CoreAudio;
  propagatedBuildInputs =
    optional stdenv.isLinux libpulseaudio;

  NIX_LDFLAGS = optionalString stdenv.isLinux "-lasound";

  meta = with stdenv.lib; {
    description = "A library for playing tracker music module files";
    homepage    = https://mikmod.shlomifish.org/;
    license     = licenses.lgpl2Plus;
    maintainers = with maintainers; [ astsmtl lovek323 ];
    platforms   = platforms.unix;

    longDescription = ''
      A library for playing tracker music module files supporting many formats,
      including MOD, S3M, IT and XM.
    '';
  };
}
