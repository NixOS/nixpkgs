{ stdenv, fetchurl, mp4v2 }:

stdenv.mkDerivation rec {
  name = "faac-1.28";

  src = fetchurl {
    url = "mirror://sourceforge/faac/${name}.tar.gz";
    sha256 = "1pqr7nf6p2r283n0yby2czd3iy159gz8rfinkis7vcfgyjci2565";
  };

  buildInputs = [ mp4v2 ];

  meta = {
    description = "Open source MPEG-4 and MPEG-2 AAC encoder";
    homepage = http://www.audiocoding.com/faac.html;
    # Incompatible with GPL. Some changes to the base code, included in faac,
    # are under LGPL though.
    license = "unfree";
  };
}
