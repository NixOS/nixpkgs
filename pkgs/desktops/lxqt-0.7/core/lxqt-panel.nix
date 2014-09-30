{ stdenv, fetchgit, pkgconfig
, cmake
, qt48

, libpthreadstubs
, libxcb # Can be removed?
, libXcomposite
, libXdmcp
# lxqt dependencies
, libqtxdg
, liblxqt
, liblxqt-mount
, lxqt-globalkeys
, libsysstat
# optional lxqt dependencies
, menu-cache

# additional optional dependencies
, icu
, alsaLib
, pulseaudio
, lm_sensors
}:

stdenv.mkDerivation rec {
  basename = "lxqt-panel";
  version = "0.7.0";
  name = "${basename}-${version}";

  src = fetchgit {
    url = "https://github.com/lxde/${basename}.git";
    rev = "07886404bd273846a785bf2ebd0260894380752e";
    sha256 = "00907276bc3c09105e26cd09875cd1ef3ba4d1c984efe5e0789c024d7e8b953b";
  };

  buildInputs = [
    stdenv pkgconfig
    cmake qt48
    libpthreadstubs libxcb libXcomposite libXdmcp
    libqtxdg liblxqt liblxqt-mount lxqt-globalkeys libsysstat
    menu-cache
    icu alsaLib pulseaudio lm_sensors
  ];

  # Patch cmake_install.cmake so that it doesn't try to install to /etc/xdg or /run/current-system/sw/etc/xdg
  postConfigure = ''
    sed -i "s@\"[^ \"]*/etc/xdg@\"$out/etc/xdg@" panel/cmake_install.cmake
  '';

  #preInstall = ''mkdir -p ${out}/etx/xdg'';

  meta = {
    homepage = "http://www.lxqt.org";
    description = "Desktop panel";
    license = stdenv.lib.licenses.lgpl21;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.ellis ];
  };
}
