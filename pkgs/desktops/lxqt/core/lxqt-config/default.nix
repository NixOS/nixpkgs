{ stdenv, fetchFromGitHub, fetchpatch, cmake, pkgconfig, lxqt-build-tools, standardPatch, qtbase, qtx11extras, qttools, qtsvg, kwindowsystem, libkscreen, liblxqt, libqtxdg, libpthreadstubs, xorg }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "lxqt-config";
  version = "0.11.1";

  srcs = fetchFromGitHub {
    owner = "lxde";
    repo = pname;
    rev = version;
    sha256 = "0mqvv93djsw49n0gxpws3hrwimnyf9kzvc2vhjkzrjfxpabk2axx";
  };

  nativeBuildInputs = [
    cmake
    pkgconfig
    lxqt-build-tools
  ];

  buildInputs = [
    qtbase
    qtx11extras
    qttools
    qtsvg
    kwindowsystem
    libkscreen
    liblxqt
    libqtxdg
    xorg.libpthreadstubs
    xorg.libXdmcp
    xorg.libXScrnSaver
    xorg.libxcb
    xorg.libXcursor
  ];

  cmakeFlags = [ "-DPULL_TRANSLATIONS=NO" ];

  postPatch = standardPatch;

  meta = with stdenv.lib; {
    description = "Tools to configure LXQt and the underlying operating system";
    homepage = https://github.com/lxde/lxqt-config;
    license = licenses.lgpl21;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };

  patches = [
    # Fixes a FTBFS with CMake v3.8
    (fetchpatch {
       url = https://github.com/lxde/lxqt-config/commit/bca652a75f8a497a69b1fbc1c7eaa353f6b4eef8.patch;
       sha256 = "17k26xj97ks9gvcjhiwc5y39fciria4xyxrzcz67zj0flqm3cmrf";
     })
  ];

}
