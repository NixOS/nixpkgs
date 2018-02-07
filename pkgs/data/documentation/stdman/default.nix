{ stdenv, curl, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "stdman-${version}";
  version = "2017.04.02";

  src = fetchFromGitHub {
    owner = "jeaye";
    repo = "stdman";
    rev = "${version}";
    sha256 = "1wfxd9ca8b9l976rnlhjd0sp364skfm99wxi633swwwjvhy26sgm";
  };

  outputDevdoc = "out";

  preConfigure = "
    patchShebangs ./configure
    patchShebangs ./do_install
  ";

  buildInputs = [ curl ];

  meta = with stdenv.lib; {
    description = "Formatted C++17 stdlib man pages (cppreference)";
    longDescription = "stdman is a tool that parses archived HTML
      files from cppreference and generates groff-formatted manual
      pages for Unix-based systems. The goal is to provide excellent
      formatting for easy readability.";
    homepage = https://github.com/jeaye/stdman;
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [ maintainers.twey ];
  };
}
