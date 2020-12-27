{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "gmqcc";
  version = "unstable-2020-10-27";

  src = fetchFromGitHub {
    owner = "graphitemaster";
    repo = "gmqcc";
    rev = "237722c0b2065f3abf32f479fffaf59105dff150";
    sha256 = "0awmrj1s9j04vwzjv28jqdpwfzlazwkdllfg0hqj8bms5pjpqld1";
  };

  doCheck = true;

  installPhase = ''
    # Install Binaries
    mkdir -pv $out/bin
    cp -v {gmqcc,qcvm} $out/bin/

    # Install man pages
    mkdir -pv $out/share/man/man1
    cp -v doc/{gmqcc,qcvm}.1 $out/share/man/man1/
  '';

  meta = with stdenv.lib; {
    homepage = "https://graphitemaster.github.io/gmqcc/index.html";
    description = "An improved QuakeC compiler";
    license = with licenses; [ mit ];
    platforms = with platforms; linux ++ darwin;
    maintainers = with maintainers; [ illiusdope ];
  };
}
