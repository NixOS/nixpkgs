{ lib
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "pysyncobj";
  version = "0.3.11";

  src = fetchFromGitHub {
    owner = "bakwc";
    repo = "PySyncObj";
    rev = version;
    sha256 = "sha256-MsyEDRla+okamffm78hoC2OwhjHLvCDQeZCzPZPbGy4=";
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
