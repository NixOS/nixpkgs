{stdenv, fetchFromGitHub}:
stdenv.mkDerivation rec {
  version = "1.8.4";
  pname = "libsixel";

  src = fetchFromGitHub {
    repo = "libsixel";
    rev = "v${version}";
    owner = "saitoha";
    sha256 = "1zckahfl0j7k68jf87iwdc4yx7fkfhxwa7lrf22dnz36d2iq785v";
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
