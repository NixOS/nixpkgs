{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  karton-core,
  malduck,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "karton-config-extractor";
  version = "2.3.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "CERT-Polska";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-a9wSw25q0blgAkR2s3brW7jGHJSLjx1yXjMmhMJNUFk=";
  };

  propagatedBuildInputs = [
    karton-core
    malduck
  ];

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "malduck==4.1.0" "malduck"
  '';

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "karton.config_extractor" ];

  meta = with lib; {
    description = "Static configuration extractor for the Karton framework";
    mainProgram = "karton-config-extractor";
    homepage = "https://github.com/CERT-Polska/karton-config-extractor";
    changelog = "https://github.com/CERT-Polska/karton-config-extractor/releases/tag/${src.tag}";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
