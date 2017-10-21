{ stdenv, fetchurl, fetchpatch, autoreconfHook
, mp4v2Support ? true, mp4v2 ? null
, drmSupport ? false # Digital Radio Mondiale
}:

assert mp4v2Support -> (mp4v2 != null);

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "faac-${version}";
  version = "1.29.3";

  src = fetchurl {
    url = "mirror://sourceforge/faac/${name}.tar.gz";
    sha256 = "0gssrz2vq52mj8x2hvdqc9bwkp64s4f4g7yj7ac6dwxs8dw8kwnf";
  };

  configureFlags = [ ]
    ++ optional mp4v2Support "--with-external-mp4v2"
    ++ optional drmSupport "--enable-drm";

  hardeningDisable = [ "format" ];

  nativeBuildInputs = [ autoreconfHook ];

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
