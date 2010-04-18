{ stdenv, fetchurl, texinfo }:
stdenv.mkDerivation rec {
  name = "libmikmod-3.1.12";
  src = fetchurl {
    url = "mirror://sourceforge/mikmod/${name}.tar.gz";
    sha256 = "0cpwpl0iqd5zsdwshw69arzlwp883bkmkx41wf3fzrh60dw2n6l9";
  };
  buildInputs = [ texinfo ];
  meta = {
    description = "A library for playing tracker music module files";
    longDescription = ''
      A library for playing tracker music module files supporting many formats,
      including MOD, S3M, IT and XM.
    '';
    homepage = http://mikmod.raphnet.net/;
    license = "LGPLv2+";
    maintainers = with stdenv.lib.maintainers; [ astsmtl ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
