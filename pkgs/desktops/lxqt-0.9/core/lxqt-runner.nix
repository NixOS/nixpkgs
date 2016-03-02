{ stdenv, fetchgit, pkgconfig
, cmake
, qt54
, kwindowsystem
, libqtxdg
, liblxqt
, lxqt-globalkeys
, standardPatch
}:

stdenv.mkDerivation rec {
  basename = "lxqt-runner";
  version = "0.9.0";
  name = "${basename}-${version}";

  src = fetchgit {
    url = "https://github.com/lxde/${basename}.git";
    rev = "de6de66013e15f149526f6eee856aeef316a3198";
    sha256 = "f13e3d9ce4eaf89b107ce8561ff22287de8abffdf11787e89e614af44967237f";
  };

  buildInputs = [
    stdenv pkgconfig
    cmake
	qt54.base qt54.tools qt54.x11extras qt54.script
	kwindowsystem
    libqtxdg liblxqt lxqt-globalkeys
  ];

  patchPhase = standardPatch;

  meta = {
    homepage = "http://www.lxqt.org";
    description = "Launch applications quickly by typing commands";
    license = stdenv.lib.licenses.lgpl21;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.ellis ];
  };
}
