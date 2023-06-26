{ lib, buildPythonPackage, fetchPypi, isPy3k
, enum34, pyyaml, pytest
}:

buildPythonPackage rec {
  version = "4.30.0";
  pname = "mt-940";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2hTi7ITWxuhWBNKmuKgAsI7GAANRrN5QHEHrZigZKVw=";
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
    description = "Module to parse MT940 files and returns smart Python collections for statistics and manipulation";
    homepage = "https://github.com/WoLpH/mt940";
    changelog = "https://github.com/wolph/mt940/releases/tag/v${version}";
    license = licenses.bsd3;
  };
}
