{ stdenv, fetchurl, fetchpatch, autoreconfHook
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

  patches = [
    (fetchpatch {
      name = "faac-mp4v2-1.9.patch";
      url = "https://git.archlinux.org/svntogit/packages.git/plain/trunk/mp4v2-1.9.patch?h=packages/faac";
      sha256 = "1pja822zw9q3cg8bjkw5z0bpxsk4q92qix26zpiqbvi7vg314hyc";
    })
    (fetchpatch {
      name = "faac-mp4v2-2.0.0.patch";
      url = "https://git.archlinux.org/svntogit/packages.git/plain/trunk/mp4v2-2.0.0.patch?h=packages/faac";
      sha256 = "07kmkrl0600rs01xqpkkw9n8p1215n485xqf8hwimp60dw3vc0wn";
      addPrefixes = true;
    })
  ];

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
