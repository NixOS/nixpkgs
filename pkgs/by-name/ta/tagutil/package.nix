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
  version = "3.1-unstable-2025-06-16";

  src = fetchFromGitHub {
    owner = "kaworu";
    repo = "tagutil";
    rev = "c8b20ef350b1a8a67a747590e2e88b41f802cce4";
    sha256 = "sha256-sKnBS9kXhJ2atN6A3qcX9A+0A7WfNkOe+nKSblL3i0o=";
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

  meta = with lib; {
    description = "Scriptable music files tags tool and editor";
    homepage = "https://github.com/kaworu/tagutil";
    license = licenses.bsd2;
    maintainers = [ ];
    platforms = platforms.linux;
    mainProgram = "tagutil";
  };
}
