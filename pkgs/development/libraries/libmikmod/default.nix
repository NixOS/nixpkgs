{ stdenv, fetchurl, texinfo, alsaLib, libpulseaudio, CoreAudio }:

let
  inherit (stdenv.lib) optional optionals optionalString;

in stdenv.mkDerivation rec {
  name = "libmikmod-3.3.11";
  src = fetchurl {
    url = "mirror://sourceforge/mikmod/${name}.tar.gz";
    sha256 = "1smb291jr4qm2cdk3gfpmh0pr23rx3jw3fw0j1zr3b4ih7727fni";
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
