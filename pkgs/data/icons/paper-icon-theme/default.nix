{ stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "${package-name}-${version}";
  package-name = "paper-icon-theme";
  version = "2016-05-25";

  src = fetchFromGitHub {
    owner = "snwh";
    repo = package-name;
    rev = "f221537532181a71938faaa1f695c762defe2626";
    sha256 = "0knsdhgssh1wyhcrbk6lddqy7zn24528lnajqij467mpgiliabfy";
  };

  nativeBuildInputs = [ autoreconfHook ];

  installPhase = ''
    make install DESTDIR="$out"
  '';

  meta = with stdenv.lib; {
    description = "Modern icon theme designed around bold colours and simple geometric shapes";
    homepage = http://snwh.org/paper;
    license = with licenses; [ cc-by-sa-40 lgpl3 ];
    platforms = platforms.all;
    maintainers = with maintainers; [ romildo ];
  };
}
