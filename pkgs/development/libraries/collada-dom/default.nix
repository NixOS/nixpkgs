{ stdenv, lib, fetchFromGitHub, cmake, boost, libxml2, minizip, readline }:

stdenv.mkDerivation {
  pname = "collada-dom";
  version = "unstable-2020-01-03";

  src = fetchFromGitHub {
    owner = "rdiankov";
    repo = "collada-dom";
    rev = "c1e20b7d6ff806237030fe82f126cb86d661f063";
    sha256 = "sha256-A1ne/D6S0shwCzb9spd1MoSt/238HWA8dvgd+DC9cXc=";
  };

  postInstall = ''
    chmod +w -R $out
    ln -s $out/include/*/* $out/include
  '';

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    boost
    libxml2
    minizip
    readline
  ];

  meta = with lib; {
    description = "Lightweight version of collada-dom, with only the parser.";
    homepage = "https://github.com/rdiankov/collada-dom";
    license = licenses.mit;
    maintainers = with maintainers; [ marius851000 ];
    platforms = platforms.all;
  };
}
