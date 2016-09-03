{ stdenv, fetchurl
, mp4v2Support ? true, mp4v2 ? null
, drmSupport ? false # Digital Radio Mondiale
}:

assert mp4v2Support -> (mp4v2 != null);

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "faac-${version}";
  version = "1.28";

  src = fetchurl {
    url = "mirror://sourceforge/faac/${name}.tar.gz";
    sha256 = "1pqr7nf6p2r283n0yby2czd3iy159gz8rfinkis7vcfgyjci2565";
  };

  configureFlags = [ ]
    ++ optional mp4v2Support "--with-mp4v2"
    ++ optional drmSupport "--enable-drm";

  hardeningDisable = [ "format" ];

  buildInputs = [ ]
    ++ optional mp4v2Support mp4v2;

  meta = {
    description = "Open source MPEG-4 and MPEG-2 AAC encoder";
    homepage    = http://www.audiocoding.com/faac.html;
    license     = licenses.unfreeRedistributable;
    maintainers = with maintainers; [ codyopel ];
    platforms   = platforms.all;
  };
}
