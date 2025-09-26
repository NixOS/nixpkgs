{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  cmake,
  scdoc,
  util-linux,
  xorg,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ydotool";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "ReimuNotMoe";
    repo = "ydotool";
    rev = "v${finalAttrs.version}";
    hash = "sha256-MtanR+cxz6FsbNBngqLE+ITKPZFHmWGsD1mBDk0OVng=";
  };

  patches = [
    (fetchpatch2 {
      url = "https://github.com/ReimuNotMoe/ydotool/commit/58fde33d9a8b393fd59348f71e80c56177b62706.patch?full_index=1";
      hash = "sha256-Ga9DPCzpJwtYVHWwKKl3kzn2BPEZBZ7uzbEY/eFXGs4=";
      includes = [ "CMakeLists.txt" ];
    })
  ];

  postPatch = ''
    substituteInPlace Daemon/ydotoold.c \
      --replace "/usr/bin/xinput" "${xorg.xinput}/bin/xinput"
    substituteInPlace Daemon/ydotool.service.in \
      --replace "/usr/bin/kill" "${util-linux}/bin/kill"
  '';

  strictDeps = true;
  nativeBuildInputs = [
    cmake
    scdoc
  ];

  passthru.tests.basic = nixosTests.ydotool;

  meta = {
    description = "Generic Linux command-line automation tool";
    homepage = "https://github.com/ReimuNotMoe/ydotool";
    license = lib.licenses.agpl3Plus;
    mainProgram = "ydotool";
    maintainers = with lib.maintainers; [
      kraem
    ];
    platforms = lib.platforms.linux;
  };
})
