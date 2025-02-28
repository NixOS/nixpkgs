{
  lib,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
  glib,
  libxml2,
}:

buildGoModule rec {
  pname = "ua";
  version = "unstable-2022-10-23";

  src = fetchFromGitHub {
    owner = "sloonz";
    repo = "ua";
    rev = "f636f5eec425754d8a8be8e767c5b3e4f31fe1f9";
    hash = "sha256-U9fApk/dyz7xSho2W8UT0OGIeOYR/v9lM0LHN2OqTEQ=";
  };

  vendorHash = "sha256-0O80uhxSVsV9N7Z/FgaLwcjZqeb4MqSCE1YW5Zd32ns=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    glib
    libxml2
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    homepage = "https://github.com/sloonz/ua";
    license = licenses.isc;
    description = "Universal Aggregator";
    maintainers = with maintainers; [ ttuegel ];
  };
}
