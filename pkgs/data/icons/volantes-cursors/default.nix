{ lib
, stdenv
, fetchFromGitHub
, inkscape
, xcursorgen
}:
stdenv.mkDerivation {
  pname = "volantes-cursors";
  version = "2022-08-27";

  src = fetchFromGitHub {
    owner = "varlesh";
    repo = "volantes-cursors";
    rev = "b13a4bbf6bd1d7e85fadf7f2ecc44acc198f8d01";
    hash = "sha256-vJe1S+YHrUBwJSwt2+InTu5ho2FOtz7FjDxu0BIA1Js=";
  };

  strictDeps = true;
  nativeBuildInputs = [ inkscape xcursorgen ];

  makeTargets = [ "build" ];

  makeFlags = [ "DESTDIR=$(out)" "PREFIX=" ];

  meta = with lib; {
    homepage = "https://www.pling.com/p/1356095/";
    description = "Classic cursor theme with a flying style";
    license = licenses.gpl2;
    maintainers = with maintainers; [ jordanisaacs ];
    platforms = platforms.unix;
    broken = stdenv.isDarwin && stdenv.isAarch64; # build timeout
  };
}
