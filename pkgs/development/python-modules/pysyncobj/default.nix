{ lib
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "pysyncobj";
  version = "0.3.8";

  src = fetchFromGitHub {
    owner = "bakwc";
    repo = "PySyncObj";
    rev = version;
    sha256 = "sha256-T7ecy5/1eF0pYaOv74SBEp6V6Z23E2b9lo5Q/gig3Cw=";
  };

  # Tests require network features
  doCheck = false;
  pythonImportsCheck = [ "pysyncobj" ];

  meta = with lib; {
    description = "Python library for replicating your class";
    homepage = "https://github.com/bakwc/PySyncObj";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
