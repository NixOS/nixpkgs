{ stdenv, fetchFromGitHub, fetchpatch, cmake }:

stdenv.mkDerivation rec {
  pname = "fmt";
  version = "6.2.0";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "fmtlib";
    repo = "fmt";
    rev = version;
    sha256 = "1vr08a8q94j66gas7ddbpdbq72b2ikd0mkgd5zd3l63610n8qajs";
  };

  patches = [
    # Fix BC break breaking Kodi
    # https://github.com/xbmc/xbmc/issues/17629
    # https://github.com/fmtlib/fmt/issues/1620
    (fetchpatch {
      url = "https://github.com/fmtlib/fmt/commit/7d01859ef16e6b65bc023ad8bebfedecb088bf81.patch";
      sha256 = "vdttRGgdltabeRAs4/z0BNtW2dLOhCxtXQFGVFKpEG0=";
    })

    # Fix paths in pkg-config file
    # https://github.com/fmtlib/fmt/pull/1657
    (fetchpatch {
      url = "https://github.com/fmtlib/fmt/commit/78f041ab5b40a1145ba686aeb8013e8788b08cd2.patch";
      sha256 = "hjE6Q/ubA4UhvuJXgcsA3wiGoDK031P19njQRL9JF8M=";
    })
  ];

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DCMAKE_SKIP_BUILD_RPATH=OFF" # for tests
  ];

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Small, safe and fast formatting library";
    longDescription = ''
      fmt (formerly cppformat) is an open-source formatting library. It can be
      used as a fast and safe alternative to printf and IOStreams.
    '';
    homepage = "http://fmtlib.net/";
    downloadPage = "https://github.com/fmtlib/fmt/";
    maintainers = [ maintainers.jdehaas ];
    license = licenses.bsd2;
    platforms = platforms.all;
  };
}
