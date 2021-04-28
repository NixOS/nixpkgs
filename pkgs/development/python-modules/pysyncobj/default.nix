{ lib
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "pysyncobj";
  version = "0.3.7";

  src = fetchFromGitHub {
    owner = "bakwc";
    repo = "PySyncObj";
    rev = version;
    sha256 = "0i7gjapaggkfvys4rgd4krpmh6mxwpzv30ngiwb6ddgp8jx0nzxk";
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
