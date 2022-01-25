{ lib, stdenv, curl, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "stdman";
  version = "2021.12.21";

  src = fetchFromGitHub {
    owner = "jeaye";
    repo = "stdman";
    rev = version;
    sha256 = "sha256-wOMQzC5w8aDmxNxQ5HK8jMgoow1wXBfHGUwFBw2WiPA=";
  };

  outputDevdoc = "out";

  preConfigure = "
    patchShebangs ./configure
    patchShebangs ./do_install
  ";

  buildInputs = [ curl ];

  meta = with lib; {
    description = "Formatted C++17 stdlib man pages (cppreference)";
    longDescription = "stdman is a tool that parses archived HTML
      files from cppreference and generates groff-formatted manual
      pages for Unix-based systems. The goal is to provide excellent
      formatting for easy readability.";
    homepage = "https://github.com/jeaye/stdman";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [ maintainers.twey ];
  };
}
