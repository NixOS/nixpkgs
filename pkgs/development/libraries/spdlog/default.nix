{ lib, stdenv, fetchFromGitHub, cmake, fmt_8, fetchpatch
, staticBuild ? stdenv.hostPlatform.isStatic
}:

stdenv.mkDerivation rec {
  pname = "spdlog";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "gabime";
    repo  = "spdlog";
    rev   = "v${version}";
    hash  = "sha256-c6s27lQCXKx6S1FhZ/LiKh14GnXMhZtD1doltU4Avws=";
  };

  # in master post 1.10.0, see https://github.com/gabime/spdlog/issues/2380
  patches = lib.optional (lib.versionAtLeast version "1.4.1") (fetchpatch {
    name = "fix-pkg-config.patch";
    url = "https://github.com/gabime/spdlog/commit/afb69071d5346b84e38fbcb0c8c32eddfef02a55.patch";
    sha256 = "0cab2bbv8zyfhrhfvcyfwf5p2fddlq5hs2maampn5w18f6jhvk6q";
  });

  nativeBuildInputs = [ cmake ];
  propagatedBuildInputs = [ fmt_8 ];

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

  meta = with lib; {
    description    = "Very fast, header only, C++ logging library";
    homepage       = "https://github.com/gabime/spdlog";
    license        = licenses.mit;
    maintainers    = with maintainers; [ obadz ];
    platforms      = platforms.all;
  };
}
