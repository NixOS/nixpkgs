{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "adapta-kde-theme";
  version = "20180828";

  src = fetchFromGitHub {
    owner = "PapirusDevelopmentTeam";
    repo = "adapta-kde";
    rev = version;
    sha256 = "1q85678sff8is2kwvgd703ckcns42gdga2c1rqlp61gb6bqf09j8";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Port of the Adapta theme for Plasma";
    homepage = "https://github.com/PapirusDevelopmentTeam/adapta-kde";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.tadfisher ];
    platforms = lib.platforms.all;
  };
}
