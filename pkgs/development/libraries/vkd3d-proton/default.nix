{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  wine,
  glslang,
}:

let
  # these are both embedded in the output files
  rev = "83308675078e9ea263fa8c37af95afdd15b3ab71";
  # git describe --tags
  shortRev = builtins.substring 0 8 rev;
  realVersion = "v2.8-302-g${shortRev}";
in

stdenv.mkDerivation rec {
  pname = "vkd3d-proton";
  version = "unstable-2023-04-21";

  nativeBuildInputs = [
    meson
    ninja
    wine
    glslang
  ];

  src = fetchFromGitHub {
    owner = "HansKristian-Work";
    repo = pname;
    inherit rev;
    sha256 = "sha256-iLpVvYmWhqy0rbbyJoT+kxzIqp68Vsb/TkihGtQQucU=";
    fetchSubmodules = true;
  };

  prePatch = ''
    substituteInPlace meson.build \
      --replace "vkd3d_build = vcs_tag(" \
                "vkd3d_build = vcs_tag( fallback : '${shortRev}'", \
      --replace "vkd3d_version = vcs_tag(" \
                "vkd3d_version = vcs_tag( fallback : '${realVersion}'",
  '';

  meta = with lib; {
    homepage = "https://github.com/HansKristian-Work/vkd3d-proton";
    description = "A fork of VKD3D, which aims to implement the full Direct3D 12 API on top of Vulkan";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ expipiplus1 ];
    platforms = platforms.all;
  };
}
