{ stdenv, fetchurl, texinfo }:

stdenv.mkDerivation rec {
  name = "libmikmod-3.3.7";

  src = fetchurl {
    url = "http://downloads.sourceforge.net/project/mikmod/libmikmod/3.3.7/libmikmod-3.3.7.tar.gz";
    sha256 = "18nrkf5l50hfg0y50yxr7bvik9f002lhn8c00nbcp6dgm5011x2c";
  };

  buildInputs = [ texinfo ];

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
