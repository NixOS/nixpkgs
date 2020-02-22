{stdenv, fetchFromGitHub}:
stdenv.mkDerivation rec {
  version = "1.8.6";
  pname = "libsixel";

  src = fetchFromGitHub {
    repo = "libsixel";
    rev = "v${version}";
    owner = "saitoha";
    sha256 = "1saxdj6sldv01g6w6yk8vr7px4bl31xca3a82j6v1j3fw5rbfphy";
  };

  configureFlags = [
    "--enable-tests"
  ];

  doCheck = true;

  meta = with stdenv.lib; {
    description = "The SIXEL library for console graphics, and converter programs";
    homepage = http://saitoha.github.com/libsixel;
    maintainers = with maintainers; [ vrthra ];
    license = licenses.mit;
    platforms = with platforms; unix;
  };
}
