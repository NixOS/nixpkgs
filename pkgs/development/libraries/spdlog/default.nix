{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, fmt
, catch2_3
, staticBuild ? stdenv.hostPlatform.isStatic

# tests
, bear, tiledb
}:

stdenv.mkDerivation rec {
  pname = "spdlog";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "gabime";
    repo  = "spdlog";
    rev   = "v${version}";
    hash  = "sha256-cxTaOuLXHRU8xMz9gluYz0a93O0ez2xOxbloyc1m1ns=";
  };

  patches = [
    # Fix a broken test, remove with the next release.
    (fetchpatch {
      url = "https://github.com/gabime/spdlog/commit/2ee8bac78e6525a8ad9a9196e65d502ce390d83a.patch";
      hash = "sha256-L79yOkm3VY01jmxNctfneTLmOA5DEQeNNGC8LbpJiOc=";
    })
  ];

  nativeBuildInputs = [ cmake ];
  propagatedBuildInputs = [ fmt ];
  checkInputs = [ catch2_3 ];

  cmakeFlags = [
    "-DSPDLOG_BUILD_SHARED=${if staticBuild then "OFF" else "ON"}"
    "-DSPDLOG_BUILD_STATIC=${if staticBuild then "ON" else "OFF"}"
    "-DSPDLOG_BUILD_EXAMPLE=OFF"
    "-DSPDLOG_BUILD_BENCH=OFF"
    "-DSPDLOG_BUILD_TESTS=ON"
    "-DSPDLOG_FMT_EXTERNAL=ON"
  ];

  outputs = [ "out" "doc" "dev" ] ;

  postInstall = ''
    mkdir -p $out/share/doc/spdlog
    cp -rv ../example $out/share/doc/spdlog
  '';

  doCheck = true;

  passthru.tests = {
    inherit bear tiledb;
  };

  meta = with lib; {
    description    = "Very fast, header only, C++ logging library";
    homepage       = "https://github.com/gabime/spdlog";
    license        = licenses.mit;
    maintainers    = with maintainers; [ obadz ];
    platforms      = platforms.all;
  };
}
