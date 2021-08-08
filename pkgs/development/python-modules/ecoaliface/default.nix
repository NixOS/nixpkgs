{ lib
, buildPythonPackage
, fetchPypi
, requests
}:

buildPythonPackage rec {
  pname = "ecoaliface";
  version = "0.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1hzx0r3311f952jik3pgmrg74xp5m6w9c5v6snfrb8w2m19vs6qy";
  };

  propagatedBuildInputs = [
    requests
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "ecoaliface" ];

  meta = with lib; {
    description = "Python library for interacting with eCoal water boiler controllers";
    homepage = "https://github.com/matkor/ecoaliface";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
