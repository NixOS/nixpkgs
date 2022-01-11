{ lib
, buildPythonPackage
, fetchFromGitHub
, requests
}:

buildPythonPackage rec {
  pname = "pymsteams";
  version = "0.1.16";

  src = fetchFromGitHub {
    owner = "rveachkc";
    repo = pname;
    rev = version;
    sha256 = "sha256-dRfzMCsU+jRdnqzIBLn1mPWr+UDq1HFfXXqe1dVhGDo=";
  };

  propagatedBuildInputs = [ requests ];

  # Tests require network access
  doCheck = false;
  pythonImportsCheck = [ "pymsteams" ];

  meta = with lib; {
    description = "Python module to interact with Microsoft Teams";
    homepage = "https://github.com/rveachkc/pymsteams";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
