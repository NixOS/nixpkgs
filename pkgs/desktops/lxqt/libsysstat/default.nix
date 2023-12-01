{ stdenv
, lib
, mkDerivation
, fetchFromGitHub
, cmake
, qtbase
, lxqt-build-tools
, gitUpdater
}:

mkDerivation rec {
  pname = "libsysstat";
  version = "0.4.6";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    hash = "sha256-dk3I+bkU2ztqIe33rTYneSUd8VFzrElTqVrjHQhAWXw=";
  };

  nativeBuildInputs = [
    cmake
    lxqt-build-tools
  ];

  buildInputs = [
    qtbase
  ];

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Library used to query system info and statistics";
    homepage = "https://github.com/lxqt/libsysstat";
    license = licenses.lgpl21Plus;
    platforms = with platforms; unix;
    maintainers = teams.lxqt.members;
  };
}
