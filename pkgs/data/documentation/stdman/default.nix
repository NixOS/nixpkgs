{ stdenv, curl, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "stdman-${version}";
  version = "d860212";

  src = fetchFromGitHub {
    owner = "jeaye";
    repo = "stdman";
    rev = "d860212767ca60472e33aa3bad22a3eac834b1f8";
    sha256 = "09c5gjhcz97ghfrv9zkgfb1wckvmqnhbzga0xidbm1ir7640di8l";
  };

  outputDocdev = "out";

  preConfigure = "
    patchShebangs ./configure
    patchShebangs ./do_install
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
