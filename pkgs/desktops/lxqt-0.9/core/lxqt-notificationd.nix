{ stdenv, fetchgit
, cmake
, qt54
, kwindowsystem
, liblxqt
, libqtxdg
, standardPatch
}:

stdenv.mkDerivation rec {
  basename = "lxqt-notificationd";
  version = "0.9.0";
  name = "${basename}-${version}";

  src = fetchgit {
    url = "https://github.com/lxde/${basename}.git";
    rev = "edf887014a1312aec61a345c298da447c4970d33";
    sha256 = "5d9d22c33c5b4b8ff660da37314d954170a41eab3258c63a1bec00220a5ed7ac";
  };

  buildInputs = [ stdenv cmake qt54.base qt54.tools qt54.x11extras kwindowsystem libqtxdg liblxqt ];

  patchPhase = standardPatch;

  meta = {
    homepage = "http://www.lxqt.org";
    description = "Notification daemon and library";
    license = stdenv.lib.licenses.lgpl21;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.ellis ];
  };
}
