{stdenv, fetchFromGitHub}:
stdenv.mkDerivation rec {
  version = "1.8.1";
  name = "libsixel-${version}";

  src = fetchFromGitHub {
    repo = "libsixel";
    rev = "v${version}";
    owner = "saitoha";
    sha256 = "0cbhvd1yk0q08nxva5bga7bpp8yxjfdfnqicvip4l6k28mzz7pmf";
  };

  meta = with stdenv.lib; {
    description = "The SIXEL library for console graphics, and converter programs";
    homepage = http://saitoha.github.com/libsixel;
    maintainers = with maintainers; [ vrthra ];
    license = licenses.mit;
    platforms = with platforms; unix;
  };
}
