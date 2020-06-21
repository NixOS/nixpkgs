{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "poica";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "Hirrolot";
    repo = pname;
    rev = "v${version}";
    sha256 = "1ghc946g8idygp1ski5ii9b5bgrgrbjfrsk35ngx7gyav794acmi";
  };

  installPhase = ''
    mkdir -p $out
    cp -r include/ $out
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/Hirrolot/poica";
    description = "ADTs with pattern matching and type introspection for pure C";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ chessai ];
  };
}
