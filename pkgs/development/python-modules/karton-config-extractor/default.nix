{ lib
, buildPythonPackage
, fetchFromGitHub
, karton-core
, malduck
}:

buildPythonPackage rec {
  pname = "karton-config-extractor";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "CERT-Polska";
    repo = pname;
    rev = "v${version}";
    sha256 = "1v0zqa81yjz6hm17x9hp0iwkllymqzn84dd6r2yrhillbwnjg9bb";
  };

  propagatedBuildInputs = [
    karton-core
    malduck
  ];

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "karton.core==4.0.5" "karton-core"
  '';

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "karton.config_extractor" ];

  meta = with lib; {
    description = "Static configuration extractor for the Karton framework";
    homepage = "https://github.com/CERT-Polska/karton-config-extractor";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
