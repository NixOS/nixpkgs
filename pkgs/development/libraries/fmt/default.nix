{ stdenv, fetchFromGitHub, fetchpatch, cmake }:

stdenv.mkDerivation rec {
  pname = "fmt";
  version = "6.2.1";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "fmtlib";
    repo = "fmt";
    rev = version;
    sha256 = "1i6nfxazq4d05r3sxyc3ziwkqq7s8rdbv9p16afv66aqmsbqqqic";
  };

  patches = [
    # Fix BC break breaking Kodi
    # https://github.com/xbmc/xbmc/issues/17629
    # https://github.com/fmtlib/fmt/issues/1620
    (fetchpatch {
      url = "https://github.com/fmtlib/fmt/commit/7d01859ef16e6b65bc023ad8bebfedecb088bf81.patch";
      sha256 = "0v8hm5958ih1bmnjr16fsbcmdnq4ykyf6b0hg6dxd5hxd126vnxx";
    })

    # Fix paths in pkg-config file
    # https://github.com/fmtlib/fmt/pull/1657
    (fetchpatch {
      url = "https://github.com/fmtlib/fmt/commit/78f041ab5b40a1145ba686aeb8013e8788b08cd2.patch";
      sha256 = "1hqp96zl9l3qyvsm7pxl6ah8c26z035q2mz2pqhqa0wvzd1klcc6";
    })

    # Fix cmake config paths.
    (fetchpatch {
      url = "https://github.com/fmtlib/fmt/pull/1702.patch";
      sha256 = "18cadqi7nac37ymaz3ykxjqs46rvki396g6qkqwp4k00cmic23y3";
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
