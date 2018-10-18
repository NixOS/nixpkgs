{ stdenv, fetchFromGitHub, python3 }:

stdenv.mkDerivation rec {
  name = "termbox-${version}";
  version = "1.1.2";
  src = fetchFromGitHub {
    owner = "nsf";
    repo = "termbox";
    rev = "v${version}";
    sha256 = "08yqxzb8fny8806p7x8a6f3phhlbfqdd7dhkv25calswj7w1ssvs";
  };
  nativeBuildInputs = [ python3 ];
  configurePhase = "python3 ./waf configure --prefix=$out";
  buildPhase = "python3 ./waf build";
  installPhase = "python3 ./waf install --destdir=$out";
  meta = with stdenv.lib; {
    description = "Library for writing text-based user interfaces";
    license = licenses.mit;
    homepage = "https://github.com/nsf/termbox#readme";
    downloadPage = "https://github.com/nsf/termbox/releases";
    maintainers = with maintainers; [ fgaz ];
  };
}

