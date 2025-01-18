{
  lib,
  stdenv,
  fetchFromGitHub,
  libX11,
  libXrandr,
}:

stdenv.mkDerivation rec {
  pname = "yeahconsole";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "jceb";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Ea6erNF9hEhDHlWLctu1SHFVoXXXsPeWUbvCBSZwn4s=";
  };

  buildInputs = [
    libX11
    libXrandr
  ];

  preConfigure = ''
    sed -i "s@PREFIX = /usr/local@PREFIX = $out@g" Makefile
  '';

  meta = with lib; {
    description = "Turns an xterm into a gamelike console";
    homepage = "https://github.com/jceb/yeahconsole";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ jceb ];
    platforms = platforms.all;
  };
}
