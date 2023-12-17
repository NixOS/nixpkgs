{ lib
, buildPythonPackage
, fetchPypi
, dukpy
, setuptools
}:

buildPythonPackage rec {
  pname = "javascripthon";
  version = "0.12";
  format = "wheel";
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7AC6cZkQQwaeQ2riALWKDiUy+6MPpFbWtLUf9/xbeX0=";
  };

  propagatedBuildInputs = [
    dukpy
    setuptools
  ];

  meta = with lib; {
    homepage = "https://github.com/metapensiero/metapensiero.pj";
    description = "A Python 3 to ES6 Javascript translator";
    license = with licenses; [ mit gpl3Plus ];
    maintainers = with maintainers; [ annaaurora ];
  };
}
