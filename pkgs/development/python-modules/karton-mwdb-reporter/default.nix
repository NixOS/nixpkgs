{ lib
, buildPythonPackage
, fetchFromGitHub
, karton-core
, mwdblib
}:

buildPythonPackage rec {
  pname = "karton-mwdb-reporter";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "CERT-Polska";
    repo = pname;
    rev = "v${version}";
    sha256 = "0jrn5c83nhcjny4bc879wrsgcr7mbazm51jzdkxmxyqf543cc841";
  };

  propagatedBuildInputs = [
    karton-core
    mwdblib
  ];

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "mwdblib==3.4.0" "mwdblib"
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
