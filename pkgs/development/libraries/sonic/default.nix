{ stdenv, fetchFromGitHub, fftw, installShellFiles }:

stdenv.mkDerivation {
  pname = "sonic";
  version = "2018-07-06";

  src = fetchFromGitHub {
    owner = "waywardgeek";
    repo = "sonic";
    rev = "71c51195de71627d7443d05378c680ba756545e8";
    sha256 = "1z9qdk3pk507hdg39v2z1hanlw2wv7mhn8br4cb8qry9z9qwi87i";
  };

  postPatch = ''
    sed -i "s,^PREFIX=.*,PREFIX=$out," Makefile
  '';

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = [ fftw ];

  postInstall = ''
    installManPage sonic.1
  '';

  meta = with stdenv.lib; {
    description = "Simple library to speed up or slow down speech";
    homepage = "https://github.com/waywardgeek/sonic";
    license = licenses.asl20;
    maintainers = with maintainers; [ aske ];
    platforms = platforms.linux;
  };
}
