{ lib, stdenv, fetchurl, fetchpatch, pkg-config, fontconfig, autoreconfHook, DiskArbitration
, withJava ? false, jdk, ant
, withAACS ? false, libaacs
, withBDplus ? false, libbdplus
, withMetadata ? true, libxml2
, withFonts ? true, freetype
}:

# Info on how to use:
# https://wiki.archlinux.org/index.php/BluRay

stdenv.mkDerivation rec {
  pname = "libbluray";
  version = "1.3.2";

  src = fetchurl {
    url = "https://get.videolan.org/libbluray/${version}/${pname}-${version}.tar.bz2";
    sha256 = "sha256-RWgU258Hwe7N736ED8uyCXbvgU34dUKL+4Hs9FhR8XA=";
  };

  patches = [
    ./BDJ-JARFILE-path.patch
    (fetchpatch {
      name = "Initial-support-for-Java-18.patch";
      url = "https://code.videolan.org/videolan/libbluray/-/commit/3187c3080096e107f0a27eed1843232b58342577.patch";
      hash = "sha256-2TSciAoPzELkgmFGB38h1RgynOCJueyCL8hIADxAPHo=";
    })
    (fetchpatch {
      name = "bd-j-BDJSecurityManager-Change-setSecurityManager-de.patch";
      url = "https://code.videolan.org/videolan/libbluray/-/commit/9a2d23d049760ef9cc9661ff90011a84d90368f1.patch";
      hash = "sha256-xCc2h5ocXCqnpVMPQaybT2Ncs2YOzifQ0mlCCUhYlc8=";
    })
  ];

  nativeBuildInputs = [ pkg-config autoreconfHook ]
    ++ lib.optionals withJava [ ant ];

  buildInputs = [ fontconfig ]
    ++ lib.optional withJava jdk
    ++ lib.optional withMetadata libxml2
    ++ lib.optional withFonts freetype
    ++ lib.optional stdenv.isDarwin DiskArbitration;

  propagatedBuildInputs = lib.optional withAACS libaacs;

  NIX_LDFLAGS = lib.optionalString withAACS "-L${libaacs}/lib -laacs"
    + lib.optionalString withBDplus " -L${libbdplus}/lib -lbdplus";

  preConfigure = lib.optionalString withJava ''
    export JDK_HOME="${jdk.home}"
  '';

  configureFlags = lib.optional (!withJava) "--disable-bdjava-jar"
    ++ lib.optional (!withMetadata) "--without-libxml2"
    ++ lib.optional (!withFonts) "--without-freetype";

  meta = with lib; {
    homepage = "http://www.videolan.org/developers/libbluray.html";
    description = "Library to access Blu-Ray disks for video playback";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ abbradar ];
    platforms = platforms.unix;
  };
}
