{ stdenv, fetchurl, texinfo }:
stdenv.mkDerivation rec {
  name = "libmikmod-3.2.0";
  src = fetchurl {
    url = "http://mikmod.shlomifish.org/files/${name}.tar.gz";
    sha256 = "07k6iyx6pyzisncgdkd071w2dhm3rx6l34hbja3wbc7rpf888k3k";
  };
  buildInputs = [ texinfo ];
  meta = {
    description = "A library for playing tracker music module files";
    longDescription = ''
      A library for playing tracker music module files supporting many formats,
      including MOD, S3M, IT and XM.
    '';
    homepage = http://mikmod.shlomifish.org/;
    license = "LGPLv2+";
    maintainers = with stdenv.lib.maintainers; [ astsmtl ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
