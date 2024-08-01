{ lib, stdenv, curl, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "stdman";
  version = "2024.07.05";

  src = fetchFromGitHub {
    owner = "jeaye";
    repo = "stdman";
    rev = version;
    sha256 = "sha256-/yJqKwJHonnBkP6/yQQJT3yPyYO6/nFAf4XFrgl3L0A=";
  };

  outputDevdoc = "out";

  preConfigure = "
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
