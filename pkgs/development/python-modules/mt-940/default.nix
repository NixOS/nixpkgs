{ lib, buildPythonPackage, fetchPypi, isPy3k
, enum34, pyyaml, pytest
}:

buildPythonPackage rec {
  version = "4.28.0";
  pname = "mt-940";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ydTOaijDmA2ogIONzRMMoz+5jr99qxWM1zzGGzg7f2Q=";
  };

  propagatedBuildInputs = lib.optional (!isPy3k) enum34;

  nativeCheckInputs = [ pyyaml pytest ];

  # requires tests files that are not present
  doCheck = false;
  checkPhase = ''
    py.test
  '';

  pythonImportsCheck = [ "mt940" ];

  meta = with lib; {
    description = "A library to parse MT940 files and returns smart Python collections for statistics and manipulation";
    homepage = "https://github.com/WoLpH/mt940";
    license = licenses.bsd3;
  };
}
