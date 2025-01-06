{
  stdenv,
  lib,
  fetchFromGitHub,
  pkg-config,
  cmake,
  libyaml,
  jansson,
  libvorbis,
  taglib,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "tagutil";
  version = "3.1";

  src = fetchFromGitHub {
    owner = "kaworu";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-oY1aGl5CKVtpOfh8Wskio/huWYMiPuxWPqxlooTutcw=";
  };

  sourceRoot = "${src.name}/src";

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    libvorbis
    libyaml
    jansson
    taglib
    zlib
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace "-o aslr" ""
  '';

  meta = {
    description = "Scriptable music files tags tool and editor";
    homepage = "https://github.com/kaworu/tagutil";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ dan4ik605743 ];
    platforms = lib.platforms.linux;
    mainProgram = "tagutil";
  };
}
