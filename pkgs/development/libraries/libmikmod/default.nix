{ stdenv, fetchurl, texinfo, alsaLib, libpulseaudio, CoreAudio }:

let
  inherit (stdenv.lib) optional optionals optionalString;

in stdenv.mkDerivation rec {
  name = "libmikmod-3.3.10";
  src = fetchurl {
    url = "mirror://sourceforge/mikmod/${name}.tar.gz";
    sha256 = "0j7g4jpa2zgzw7x6s3rldypa7zlwjvn97rwx0sylx1iihhlzbcq0";
  };

  buildInputs = [ texinfo ]
    ++ optionals stdenv.isLinux [ alsaLib libpulseaudio ]
    ++ optional stdenv.isDarwin CoreAudio;
  propagatedBuildInputs =
    optional stdenv.isLinux libpulseaudio;

  NIX_LDFLAGS = optionalString stdenv.isLinux "-lasound";

  meta = with stdenv.lib; {
    description = "A library for playing tracker music module files";
    homepage    = http://mikmod.shlomifish.org/;
    license     = licenses.lgpl2Plus;
    maintainers = with maintainers; [ astsmtl lovek323 ];
    platforms   = platforms.unix;

    longDescription = ''
      A library for playing tracker music module files supporting many formats,
      including MOD, S3M, IT and XM.
    '';
  };
}
