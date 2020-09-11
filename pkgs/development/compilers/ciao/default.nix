{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "ciao";
  version = "1.19.0";
  src = fetchFromGitHub {
    owner = "ciao-lang";
    repo = "ciao";
    rev = "v${version}";
    sha256 = "03qzcb4ivgkiwdpw7a94dn74xqyxjwz5ilrr53rcblsh5ng299jp";
  };

  configurePhase = ''
    ./ciao-boot.sh configure --instype=global --prefix=$prefix
  '';

  buildPhase = ''
    ./ciao-boot.sh build
  '';

  installPhase = ''
    ./ciao-boot.sh install
  '';

  meta = with stdenv.lib; {
    homepage = "https://ciao-lang.org/";
    description = "A general purpose, multi-paradigm programming language in the Prolog family";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ suhr ];
    platforms = platforms.unix;
  };
}
