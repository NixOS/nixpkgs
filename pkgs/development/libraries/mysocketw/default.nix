{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, fetchurl
, openssl
, cmake
}:

let

  joinpaths-src = fetchurl {
    url = "https://github.com/AnotherFoxGuy/CMakeCM/raw/afe41f4536ae21f6f11f83e8c0b8b8c450ef1332/modules/JoinPaths.cmake";
    hash = "sha256-eUsNj6YqO3mMffEtUBFFgNGkeiNL+2tNgwkutkam7MQ=";
  };

in
stdenv.mkDerivation rec {
  pname = "mysocketw";
  version = "3.11.0";

  src = fetchFromGitHub {
    owner = "RigsOfRods";
    repo = "socketw";
    rev = version;
    hash = "sha256-mpfhmKE2l59BllkOjmURIfl17lAakXpmGh2x9SFSaAo=";
  };

  patches = [
    # in master post 3.11.0, see https://github.com/RigsOfRods/socketw/issues/16
    (fetchpatch {
      name = "fix-pkg-config.patch";
      url = "https://github.com/RigsOfRods/socketw/commit/17cad062c3673bd0da74a2fecadb01dbf9813a07.patch";
      sha256 = "01b019gfm01g0r1548cizrf7mqigsda8jnrzhg8dhi9c49nfw1bp";
    })
  ];

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    openssl
  ];

  postUnpack = ''(
    mkdir -p source/build/_cmcm-modules/resolved && cd $_
    cp ${joinpaths-src} JoinPaths.cmake
    printf %s 'https://AnotherFoxGuy.com/CMakeCM::modules/JoinPaths.cmake.1' > JoinPaths.cmake.whence
  )'';

  meta = with lib; {
    description = "Cross platform (Linux/FreeBSD/Unix/Win32) streaming socket C++";
    homepage = "https://github.com/RigsOfRods/socketw";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };
}
