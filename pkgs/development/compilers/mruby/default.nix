{ stdenv, ruby, bison, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "mruby-${version}";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner   = "mruby";
    repo    = "mruby";
    rev     = version;
    sha256  = "0pw72acbqgs4n1qa297nnja23v9hxz9g7190yfx9kwm7mgbllmww";
  };

  nativeBuildInputs = [ ruby bison ];

  installPhase = ''
    mkdir $out
    cp -R build/host/{bin,lib} $out
  '';

  meta = with stdenv.lib; {
    description = "An embeddable implementation of the Ruby language";
    homepage = https://mruby.org;
    maintainers = [ maintainers.nicknovitski ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
