{ lib, stdenv, fetchFromGitHub
, meson, ninja, pkg-config
, python3
, icu
, libuuid
, xapian
, xz
, zstd
, gtest
}:

stdenv.mkDerivation rec {
  pname = "zimlib";
  version = "6.3.2";

  src = fetchFromGitHub {
    owner = "openzim";
    repo = "libzim";
    rev = version;
    sha256 = "sha256-xlYu74akK9WFy86hcQe7zp11TImwl8llgDIZBRgmbAI=";
  };

  nativeBuildInputs = [
    meson
    pkg-config
    ninja
    python3
  ];

  propagatedBuildInputs = [
    icu
    libuuid
    xapian
    xz
    zstd
  ];

  postPatch = ''
    patchShebangs scripts
  '';

  checkInputs = [
    gtest
  ];

  doCheck = true;

  meta = with lib; {
    description = "Library for reading and writing ZIM files";
    homepage =  "https://www.openzim.org/wiki/Zimlib";
    license = licenses.gpl2;
    maintainers = with maintainers; [ ajs124 ];
    platforms = platforms.linux;
  };
}
