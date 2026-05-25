{
  buildDunePackage,
  fetchFromGitHub,
  lib,
}:

buildDunePackage {
  pname = "calendars";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "geneweb";
    repo = "calendars";
    rev = "v2.0.0";
    hash = "sha256-bDTQr/uG3Yv1dNC10QpbBKPXAgT7p8TkUAx3dALKKpk=";
  };

  meta = with lib; {
    description = "Calendar conversions handling Gregorian, Julian, French Republican and Hebrew";
    homepage = "https://github.com/geneweb/calendars";
    license = licenses.isc;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = [ lib.maintainers.darkone ];
  };
}
