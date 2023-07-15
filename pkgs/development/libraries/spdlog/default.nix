{ lib, stdenv, fetchFromGitHub, fetchpatch, cmake, fmt
, staticBuild ? stdenv.hostPlatform.isStatic

# tests
, bear, tiledb
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

  patches = [
    # Fix compatiblity with fmt 10.0. Remove with the next release
    (fetchpatch {
      url = "https://github.com/gabime/spdlog/commit/0ca574ae168820da0268b3ec7607ca7b33024d05.patch";
      hash = "sha256-cRsQilkyUQW47PFpDwKgU/pm+tOeLvwPx32gNOPAO1U=";
    })
    (fetchpatch {
      url = "https://github.com/gabime/spdlog/commit/af1785b897c9d1098d4aa7213fad232be63c19b4.patch";
      hash = "sha256-zpfLiBeDAOsvk4vrIyXC0kvFe2WkhAhersd+fhA8DFY=";
    })
  ];

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
