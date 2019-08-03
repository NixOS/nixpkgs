{stdenv, fetchFromGitHub}:
stdenv.mkDerivation rec {
  version = "1.8.2";
  name = "libsixel-${version}";

  src = fetchFromGitHub {
    repo = "libsixel";
    rev = "v${version}";
    owner = "saitoha";
    sha256 = "1jn5z2ylccjkp9i12n5x53x2zzhhsgmgs6xxi7aja6qimfw90h1n";
  };

  meta = with stdenv.lib; {
    description = "The SIXEL library for console graphics, and converter programs";
    homepage = http://saitoha.github.com/libsixel;
    maintainers = with maintainers; [ vrthra ];
    license = licenses.mit;
    platforms = with platforms; unix;
  };
}
