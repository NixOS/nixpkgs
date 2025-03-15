{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  docopt_cpp,
  file,
  gumbo,
  mustache-hpp,
  libzim,
  icu,
  zlib,
  gtest,
}:

stdenv.mkDerivation rec {
  pname = "zim-tools";
  version = "3.5.0";

  src = fetchFromGitHub {
    owner = "openzim";
    repo = "zim-tools";
    tag = version;
    hash = "sha256-gcCo3u1pLm1CnTF3CATOri5+zat839zUbmQnMOVjanI=";
  };

  patches = [
    # Took from:
    # https://gitlab.archlinux.org/archlinux/packaging/packages/zim-tools/-/blob/0b4ffc61be76f1cfc61500f8157f99e28bb3c7b1/0001-Fix-build-with-ICU-76.patch
    # https://github.com/openzim/libzim/pull/936
    ./fix_build_with_icu76.patch
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    docopt_cpp
    file
    gumbo
    mustache-hpp
    libzim
    icu
    zlib
  ];

  nativeCheckInputs = [ gtest ];
  doCheck = true;

  meta = {
    description = "Various ZIM command line tools";
    homepage = "https://github.com/openzim/zim-tools";
    maintainers = with lib.maintainers; [ robbinch ];
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
  };
}
