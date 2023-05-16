<<<<<<< HEAD
{ lib, stdenv, fetchgit, graphviz, gtk2, gtkmm2, pkg-config, python3, waf }:
=======
{ lib, stdenv, fetchgit, graphviz, gtk2, gtkmm2, pkg-config, python3, wafHook }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

stdenv.mkDerivation rec {
  pname = "ganv";
  version = "unstable-2019-12-30";

  src = fetchgit {
    url = "https://gitlab.com/drobilla/${pname}.git";
    fetchSubmodules = true;
    rev = "90bd022f8909f92cc5290fdcfc76c626749e1186";
    sha256 = "01znnalirbqxpz62fbw2c14c8xn117jc92xv6dhb3hln92k9x37f";
  };

<<<<<<< HEAD
  nativeBuildInputs = [ pkg-config waf.hook python3 gtk2 ];
=======
  nativeBuildInputs = [ pkg-config wafHook python3 gtk2 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  buildInputs = [ graphviz gtkmm2 ];

  strictDeps = true;

  meta = with lib; {
    description = "An interactive Gtk canvas widget for graph-based interfaces";
    homepage = "http://drobilla.net";
    license = licenses.gpl3;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
  }
