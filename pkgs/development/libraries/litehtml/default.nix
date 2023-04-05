{ lib
, stdenv
, fetchFromGitHub
, cmake
, gumbo
}:

stdenv.mkDerivation rec {
  pname = "litehtml";
  version = "0.6";

  src = fetchFromGitHub {
    owner = "litehtml";
    repo = "litehtml";
    rev = "v${version}";
    hash = "sha256-9571d3k8RkzEpMWPuIejZ7njLmYstSwFUaSqT3sk6uQ=";
  };

  # Don't search for non-existant gumbo cmake config
  # This will mislead cmake that litehtml is not found
  # Affects build of pkgs that depend on litehtml
  postPatch = ''
    substituteInPlace cmake/litehtmlConfig.cmake \
      --replace "find_dependency(gumbo)" ""
  '';

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    gumbo
  ];

  cmakeFlags = [
    "-DEXTERNAL_GUMBO=ON"
  ];

  meta = with lib; {
    description = "Fast and lightweight HTML/CSS rendering engine";
    homepage = "http://www.litehtml.com/";
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = with maintainers; [ fgaz ];
  };
}
