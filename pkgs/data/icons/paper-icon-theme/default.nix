{ stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "${package-name}-${version}";
  package-name = "paper-icon-theme";
  version = "2016-05-21";

  src = fetchFromGitHub {
    owner = "snwh";
    repo = package-name;
    rev = "f2a34cab78df0fa7db5a10e93e633953cb7c1eb7";
    sha256 = "0pk848jbskkwz7im73119hcrcyr5nim37jcdrhqf4cwrshmbcacq";
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
