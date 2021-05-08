{ lib
, buildPythonPackage
, fetchFromGitHub
, karton-core
, malduck
}:

buildPythonPackage rec {
  pname = "karton-config-extractor";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "CERT-Polska";
    repo = pname;
    rev = "v${version}";
    sha256 = "14592b9vq2iza5agxr29z1mh536if7a9p9hvyjnibsrv22mzwz7l";
  };

  propagatedBuildInputs = [
    karton-core
    malduck
  ];

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "karton-core==4.2.0" "karton-core"
    substituteInPlace requirements.txt \
      --replace "malduck==4.1.0" "malduck"
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
