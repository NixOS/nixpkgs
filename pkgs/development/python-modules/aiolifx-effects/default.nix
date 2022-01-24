{ lib
, fetchPypi
, buildPythonPackage
, isPy3k
, aiolifx
}:

buildPythonPackage rec {
  pname = "aiolifx-effects";
  version = "0.2.2";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit version;
    pname = "aiolifx_effects";
    sha256 = "sha256-qkXJDYdJ+QyQWn/u7g6t4QJG1uSqle+a5RhTkPPsHKo=";
  };

  propagatedBuildInputs = [ aiolifx ];

  # tests are not implemented
  doCheck = false;

  pythonImportsCheck = [ "aiolifx_effects" ];

  meta = with lib; {
    homepage = "https://github.com/amelchio/aiolifx_effects";
    license = licenses.mit;
    description = "Light effects (pulse, colorloop ...) for LIFX lights running on aiolifx";
    maintainers = with maintainers; [ netixx ];
  };
}
