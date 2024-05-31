{ lib, stdenv, fetchgit, graphviz, gtk2, gtkmm2, pkg-config, python3, wafHook }:

stdenv.mkDerivation rec {
  pname = "ganv";
  version = "unstable-2019-12-30";

  src = fetchgit {
    url = "https://gitlab.com/drobilla/${pname}.git";
    fetchSubmodules = true;
    rev = "90bd022f8909f92cc5290fdcfc76c626749e1186";
    sha256 = "01znnalirbqxpz62fbw2c14c8xn117jc92xv6dhb3hln92k9x37f";
  };

  nativeBuildInputs = [ pkg-config wafHook python3 gtk2 ];
  buildInputs = [ graphviz gtkmm2 ];

  strictDeps = true;

  meta = with lib; {
    description = "An interactive Gtk canvas widget for graph-based interfaces";
    mainProgram = "ganv_bench";
    homepage = "http://drobilla.net";
    license = licenses.gpl3;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
  }
