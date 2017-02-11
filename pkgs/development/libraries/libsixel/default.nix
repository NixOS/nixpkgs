{stdenv, fetchFromGitHub}:
stdenv.mkDerivation rec {
  version = "1.7.3";
  name = "libsixel-${version}";

  src = fetchFromGitHub {
    repo = "libsixel";
    rev = "v${version}";
    owner = "saitoha";
    sha256 = "1hzmypzzigmxl07vgc52wp4dgxkhya3gfk4yzaaxc8s630r6ixs8";
  };

  meta = with stdenv.lib; {
    description = "The SIXEL library for console graphics, and converter programs";
    homepage = http://saitoha.github.com/libsixel;
    maintainers = with maintainers; [ vrthra ];
    license = licenses.mit;
    platforms = with platforms; unix;
  };
}
