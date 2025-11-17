{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  ppx_expect,
  astring,
  curly,
  fmt,
  logs,
  ppx_yojson_conv,
  ppx_yojson_conv_lib,
  yojson,
  alcotest,
}:

buildDunePackage rec {
  pname = "get-activity-lib";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "tarides";
    repo = "get-activity";
    rev = version;
    hash = "sha256-QU/LPIxcem5nFvSxcNApOuBu6UHqLHIXVSOJ2UT0eKA=";
  };

  minimalOCamlVersion = "4.08";

  buildInputs = [ ppx_yojson_conv ];

  propagatedBuildInputs = [
    astring
    curly
    fmt
    logs
    ppx_yojson_conv_lib
    yojson
  ];

  checkInputs = [
    ppx_expect
    alcotest
  ];

  doCheck = true;

  meta = {
    homepage = "https://github.com/tarides/get-activity";
    description = "Collect activity and format as markdown for a journal (lib)";
    license = lib.licenses.mit;
    changelog = "https://github.com/tarides/get-activity/releases/tag/${version}";
    maintainers = with lib.maintainers; [ zazedd ];
  };
}
