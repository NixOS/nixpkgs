{ lib
, fetchPypi
, buildPythonPackage
, isPy3k
, aiolifx
}:

buildPythonPackage rec {
  pname = "aiolifx-effects";
  version = "0.2.1";

  src = fetchPypi {
    inherit version;
    pname = "aiolifx_effects";
    sha256 = "cb4ac52deeb220783fc6449251cf40833fcffa28648270be64b1b3e83e06b503";
  };

  # tests are not implemented
  doCheck = false;

  disabled = !isPy3k;

  propagatedBuildInputs = [ aiolifx ];

  meta = with lib; {
    homepage = https://github.com/amelchio/aiolifx_effects;
    license = licenses.mit;
    description = "Light effects (pulse, colorloop ...) for LIFX lights running on aiolifx";
    maintainers = with maintainers; [ netixx ];
  };
}
