{ lib, stdenv, fetchFromGitHub, python3 }:

stdenv.mkDerivation rec {
  pname = "wolfebin";
  version = "5.6";

  src = fetchFromGitHub {
    owner = "thejoshwolfe";
    repo = "wolfebin";
    rev = version;
    sha256 = "sha256-tsI71/UdLaGZ3O2lNTd1c8S5OS2imquLovh0n0ez8Ts=";
  };

  buildInputs = [ python3 ];

  installPhase = ''
    install -m 755 -d $out/bin
    install -m 755 wolfebin $out/bin
    install -m 755 wolfebin_server.py $out/bin/wolfebin_server
  '';

  meta = with lib; {
    homepage = "https://github.com/thejoshwolfe/wolfebin";
    description = "Quick and easy file sharing";
    license = licenses.mit;
    maintainers = with maintainers; [ andrewrk ];
    platforms = platforms.all;
  };
}
