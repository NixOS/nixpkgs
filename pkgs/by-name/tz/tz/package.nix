{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "tz";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "oz";
    repo = "tz";
    rev = "v${version}";
    sha256 = "sha256-Mnb0GdJ9dgaUanWBP5JOo6++6MfrUgncBRp4NIbhxf0=";
  };

  vendorHash = "sha256-lcCra4LyebkmelvBs0Dd2mn6R64Q5MaUWc5AP8V9pec=";

  meta = {
    description = "Time zone helper";
    homepage = "https://github.com/oz/tz";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ siraben ];
    mainProgram = "tz";
  };
}
