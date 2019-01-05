{ stdenv, fetchFromGitHub, pkgconfig, glib, cairo, Carbon, fontconfig
, libtiff, giflib, libjpeg, libpng
, libXrender, libexif, autoreconfHook, fetchpatch }:

stdenv.mkDerivation rec {
  name = "libgdiplus-5.6";

  src = fetchFromGitHub {
    owner = "mono";
    repo = "libgdiplus";
    rev = "5.6";
    sha256 = "11xr84kng74j3pd8sx74q80a71k6dw0a502qgibcxlyqh666lfb7";
  };

  NIX_LDFLAGS = "-lgif";

  patches = [ # Series of patches cherry-picked from master, all fixes various sigsegv (or required by other patch)
    (fetchpatch {
          url = "https://github.com/mono/libgdiplus/commit/d33a2580a94701ff33abe28c22881d6173be57d0.patch";
          sha256 = "0rr54jylscn4icqjprqhwrncyr92r0d7kmfrrq3myskplpqv1c11";
    })
    (fetchpatch {
          url ="https://github.com/mono/libgdiplus/commit/aa6aa53906935572f52f519fe4ab9ebedc051d08.patch";
          sha256 = "1wg0avm8qv5cb4vk80baflfzszm6q7ydhn89c3h6kq68hg6zsf1f";
    })
    (fetchpatch {
          url = "https://github.com/mono/libgdiplus/commit/81e45a1d5a3ac3cf035bcc3fabb2859818b6cc04.patch";
          sha256 = "07wmc88cd1lqifs5x6npryni65jyy9gi8lgr2i1lb7v0fhvlyswg";
    })
  ];

  hardeningDisable = [ "format" ];

  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  buildInputs =
    [ glib cairo fontconfig libtiff giflib
      libjpeg libpng libXrender libexif
    ]
    ++ stdenv.lib.optional stdenv.isDarwin Carbon;

  postInstall = stdenv.lib.optionalString stdenv.isDarwin ''
    ln -s $out/lib/libgdiplus.0.dylib $out/lib/libgdiplus.so
  '';

  checkPhase = ''
    make check -w
  '';

  meta = with stdenv.lib; {
    description = "Mono library that provides a GDI+-compatible API on non-Windows operating systems";
    homepage = https://www.mono-project.com/docs/gui/libgdiplus/;
    platforms = platforms.unix;
    license = licenses.mit;
  };
}
