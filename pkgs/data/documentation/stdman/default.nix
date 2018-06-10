{ stdenv, curl, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "stdman-${version}";
  version = "2018.03.11";

  src = fetchFromGitHub {
    owner = "jeaye";
    repo = "stdman";
    rev = "${version}";
    sha256 = "1017vwhcwlwi5sa8h6pkhj048in826wxnhl6qarykmzksvidff3r";
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
