{ stdenv, fetchurl, texinfo }:
stdenv.mkDerivation rec {
  name = "libmikmod-3.2.0";
  src = fetchurl {
    url = "http://mikmod.shlomifish.org/files/${name}.tar.gz";
    sha256 = "07k6iyx6pyzisncgdkd071w2dhm3rx6l34hbja3wbc7rpf888k3k";
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
