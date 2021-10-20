{ lib
, autoit-ripper
, buildPythonPackage
, fetchFromGitHub
, karton-core
, malduck
, regex
}:

buildPythonPackage rec {
  pname = "karton-autoit-ripper";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "CERT-Polska";
    repo = pname;
    rev = "v${version}";
    sha256 = "1bsqpf9w6d9fjysmnafaglg2w41gsafs2xz4dzcgc7n92shpcs8w";
  };

  propagatedBuildInputs = [
    autoit-ripper
    karton-core
    malduck
    regex
  ];

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "autoit-ripper==1.0.0" "autoit-ripper" \
      --replace "malduck==3.1.0" "malduck>=3.1.0" \
      --replace "regex==2020.2.20" "regex>=2020.2.20"
  '';

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "karton.autoit_ripper" ];

  meta = with lib; {
    description = "AutoIt script ripper for Karton framework";
    homepage = "https://github.com/CERT-Polska/karton-autoit-ripper";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
