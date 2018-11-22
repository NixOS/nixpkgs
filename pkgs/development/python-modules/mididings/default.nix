{ lib
, buildPythonPackage
, stdenv
, python
, fetchFromGitHub
, pkgs
, libjack2
, alsaLib
, pkgconfig
, glib
, boost
, python36Packages
}:

buildPythonPackage rec {
  pname = "mididings";
  version = "unstable-2015-11-17";

  patches = [ ./0001-add-boost-suffix.patch ];

  LIBRARY_PATH="${(pkgs.boost.override {enablePython = true; inherit python; })}/lib";
  
  nativeBuildInputs = [ 
    pkgconfig 
  ];

  buildInputs = with pkgs; [
    (boost.override {
      enablePython = true;
      inherit python;
    })
    glib
    libjack2
    alsaLib
  ];

  propagatedBuildInputs = [
    python36Packages.decorator 
    python36Packages.pyliblo 
    python36Packages.dbus-python
    python36Packages.pyinotify 
    python36Packages.tkinter  
  ];


  checkInputs = [ 
    python36Packages.pytest 
  ];

  src = fetchFromGitHub {
    owner = "dsacre";
    repo = "mididings";
    rev = "bbec99a8c878a2a7029e78e84fc736e4a68ed5a0";
    sha256 = "1pdf5mib87zy7yjh9vpasja419h28wvgq6x5hw2hkm7bg9ds4p2m";
  };

  meta = {
    description = "midi router";
    homepage = https://github.com/dsacre/mididings;
    license = lib.licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ hark ];
    platforms = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;

  };
}
