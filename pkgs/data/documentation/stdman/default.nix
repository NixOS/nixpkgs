{ stdenv, curl, fetchgit }:

stdenv.mkDerivation rec {
  name = "stdman-${version}";
  version = "d860212";

  src = fetchgit {
    url = "git://github.com/jeaye/stdman";
    sha256 = "0fr4bw6rsddf95chdlwami9q1fwwfbk4di35zzi25zg72ibi12qz";
    rev = "d860212767ca60472e33aa3bad22a3eac834b1f8";
  };

  preConfigure = "
    substituteInPlace configure --replace /bin/bash /bin/sh;
    substituteInPlace do_install --replace /bin/bash /bin/sh;
  ";

  buildInputs = [ curl ];
  
  meta = with stdenv.lib; {
    description = "Formatted C++11/14 stdlib man pages (cppreference)";
    longDescription = "stdman is a tool that parses archived HTML
      files from cppreference and generates groff-formatted manual
      pages for Unix-based systems. The goal is to provide excellent
      formatting for easy readability.";
    homepage = https://github.com/jeaye/stdman;
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.twey ];
  };
}
