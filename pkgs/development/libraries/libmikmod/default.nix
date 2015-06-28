{ stdenv, fetchurl, texinfo, alsaLib, libpulseaudio }:

stdenv.mkDerivation rec {
  name = "libmikmod-3.3.7";
  src = fetchurl {
    url = "mirror://sourceforge/mikmod/${name}.tar.gz";
    sha256 = "18nrkf5l50hfg0y50yxr7bvik9f002lhn8c00nbcp6dgm5011x2c";
  };

  buildInputs = [ texinfo ]
    ++ stdenv.lib.optional stdenv.isLinux [ alsaLib libpulseaudio ];
  propagatedBuildInputs =
    stdenv.lib.optional stdenv.isLinux libpulseaudio;

  NIX_LDFLAGS = stdenv.lib.optionalString stdenv.isLinux "-lasound";

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
