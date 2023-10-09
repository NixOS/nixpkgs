{ lib, stdenv, fetchurl, ncurses }:

stdenv.mkDerivation rec {
  pname = "cdk";
  version = "5.0-20230201";

  src = fetchurl {
    urls = [
      "ftp://ftp.invisible-island.net/cdk/cdk-${version}.tgz"
      "https://invisible-mirror.net/archives/cdk/cdk-${version}.tgz"
    ];
    hash = "sha256-oxJ7Wf5QX16Jjao90VsM9yShJ0zmgWW3eb4vKdTE8vY=";
  };

  buildInputs = [
    ncurses
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Curses development kit";
    homepage = "https://invisible-island.net/cdk/";
    changelog = "https://invisible-island.net/cdk/CHANGES";
    license = licenses.mit;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
  };
}
