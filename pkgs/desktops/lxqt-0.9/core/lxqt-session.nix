{ stdenv, fetchgit, pkgconfig
, cmake
, libpthreadstubs, libXdmcp
, qt54
, kwindowsystem
, libqtxdg
, liblxqt
, standardPatch
}:

stdenv.mkDerivation rec {
  basename = "lxqt-session";
  version = "0.9.0";
  name = "${basename}-${version}";

  src = fetchgit {
    url = "https://github.com/lxde/${basename}.git";
    rev = "9877c3be90d00b94020ddd131a983864e1a77a62";
    sha256 = "75344026c533648f63790f8c50978c65cb0ecceb382ab793ca6c991b1072c6cc";
  };

  buildInputs = [
    stdenv pkgconfig
    cmake
    qt54.base qt54.tools qt54.x11extras
    libpthreadstubs libXdmcp
    kwindowsystem
    libqtxdg liblxqt
  ];

  patchPhase = standardPatch;

#  preConfigure = ''
#    cmakeFlags="-DLIB_SUFFIX="
#  '';

  meta = {
    homepage = "http://www.lxqt.org";
    description = "session manager";
    license = stdenv.lib.licenses.lgpl21;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.ellis ];
  };
}
