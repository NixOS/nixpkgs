{ lib
, buildPythonPackage
, chardet
, fetchFromGitHub
, karton-core
, mwdblib
, python
}:

buildPythonPackage rec {
  pname = "karton-mwdb-reporter";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "CERT-Polska";
    repo = pname;
    rev = "v${version}";
    sha256 = "0ks8jrc4v87q6zhwqg40w6xv2wfkzslmnfmsmmkfjj8mak8nk70f";
  };

  propagatedBuildInputs = [
    karton-core
    mwdblib
  ];

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "karton-core==4.0.4" "karton-core" \
      --replace "mwdblib==3.3.1" "mwdblib"
  '';

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "karton.mwdb_reporter" ];

  meta = with lib; {
    description = "Karton service that uploads analyzed artifacts and metadata to MWDB Core";
    homepage = "https://github.com/CERT-Polska/karton-mwdb-reporter";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
