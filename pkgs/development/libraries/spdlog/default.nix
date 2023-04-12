{ lib, stdenv, fetchFromGitHub, cmake, fmt
, staticBuild ? stdenv.hostPlatform.isStatic
}:

stdenv.mkDerivation rec {
  pname = "spdlog";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "gabime";
    repo  = "spdlog";
    rev   = "v${version}";
    hash  = "sha256-kA2MAb4/EygjwiLEjF9EA7k8Tk//nwcKB1+HlzELakQ=";
  };

  nativeBuildInputs = [ cmake ];
  propagatedBuildInputs = [ fmt ];

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
