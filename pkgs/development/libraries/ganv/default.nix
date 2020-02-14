{ stdenv, fetchgit, graphviz, gtk2, gtkmm2, pkgconfig, python, wafHook }:

stdenv.mkDerivation rec {
  pname = "ganv";
  version = "unstable-2019-12-30";

  src = fetchgit {
    url = "https://gitlab.com/drobilla/${pname}.git";
    fetchSubmodules = true;
    rev = "90bd022f8909f92cc5290fdcfc76c626749e1186";
    sha256 = "01znnalirbqxpz62fbw2c14c8xn117jc92xv6dhb3hln92k9x37f";
  };

  nativeBuildInputs = [ pkgconfig wafHook ];
  buildInputs = [ graphviz gtk2 gtkmm2 python ];

  meta = with stdenv.lib; {
    description = "An interactive Gtk canvas widget for graph-based interfaces";
    homepage = http://drobilla.net;
    license = licenses.gpl3;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
  }
