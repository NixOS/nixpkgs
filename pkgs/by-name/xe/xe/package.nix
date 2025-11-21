{
  stdenv,
  lib,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "xe";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "leahneukirchen";
    repo = "xe";
    tag = "v${version}";
    sha256 = "sha256-yek6flBhgjSeN3M695BglUfcbnUGp3skzWT2W/BxW8Y=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Simple xargs and apply replacement";
    homepage = "https://github.com/leahneukirchen/xe";
    license = lib.licenses.cc0;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.pbsds ];
    mainProgram = "xe";
  };
}
