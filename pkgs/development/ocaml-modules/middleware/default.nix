{ lib
, buildDunePackage
, fetchurl
, alcotest
}:

buildDunePackage rec {
  pname = "middleware";
  version = "0.0.1";

  minimalOCamlVersion = "4.14.0";

  src = fetchurl {
    url = "https://github.com/skolemlabs/middleware/releases/download/${version}/${pname}-${version}.tbz";
    hash = "sha256-zhLEGvyZiKrdBKWcEbB4PHvYzBlkrp1Ldnon0mP2Ypg=";
  };

  checkInputs = [
    alcotest
  ];

  doCheck = true;

  meta = {
    description = "Composable stacked functions, which can respond to inner calls";
    homepage = "https://github.com/skolemlabs/middleware";
    changelog = "https://github.com/skolemlabs/middleware/blob/${version}/CHANGES.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sixstring982 ];
  };
}

