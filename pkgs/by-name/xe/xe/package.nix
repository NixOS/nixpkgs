{
  stdenv,
  lib,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "xe";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "chneukirchen";
    repo = "xe";
    rev = "v${version}";
    sha256 = "sha256-yek6flBhgjSeN3M695BglUfcbnUGp3skzWT2W/BxW8Y=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Simple xargs and apply replacement";
    homepage = "https://github.com/chneukirchen/xe";
    license = lib.licenses.publicDomain;
    platforms = lib.platforms.all;
    maintainers = [ ];
    mainProgram = "xe";
  };
}
