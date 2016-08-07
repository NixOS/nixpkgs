{stdenv, fetchFromGitHub}:
stdenv.mkDerivation rec {
  version = "1.6.1";
  name = "libsixel-${version}";

  src = fetchFromGitHub {
    repo = "libsixel";
    rev = "ef4374f80385edc48e0844cf324d7ef757688e44";
    owner = "saitoha";
    sha256 = "08m5q2ppk235bzbwff1wg874vr1bh4080qdj26l39v8lw1xzlqcp";
  };

  meta = with stdenv.lib; {
    description = "The SIXEL library for console graphics, and converter programs";
    homepage = http://saitoha.github.com/libsixel;
    maintainers = with maintainers; [ vrthra ];
    license = licenses.mit;
    platforms = with platforms; unix;
  };
}
