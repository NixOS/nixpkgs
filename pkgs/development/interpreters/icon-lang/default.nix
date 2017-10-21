{ stdenv, fetchFromGitHub, libX11, libXt }:

stdenv.mkDerivation rec {
  name = "icon-lang-${version}";
  version = "9.5.1";
  src = fetchFromGitHub {
    rev = "39d7438e8d23ccfe20c0af8bbbf61e34d9c715e9";
    owner = "gtownsend";
    repo = "icon";
    sha256 = "1gkvj678ldlr1m5kjhx6zpmq11nls8kxa7pyy64whgakfzrypynw";
  };
  buildInputs = [ libX11 libXt ];

  configurePhase = ''
    make X-Configure name=linux
  '';

  installPhase = ''
    make Install dest=$out
  '';

  meta = with stdenv.lib; {
    description = ''A very high level general-purpose programming language'';
    maintainers = with maintainers; [ vrthra ];
    platforms = platforms.linux;
    license = licenses.publicDomain;
    homepage = https://www.cs.arizona.edu/icon/;
  };
}
