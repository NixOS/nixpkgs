{ lib
, buildPythonPackage
, fetchFromGitHub
, requests
}:

buildPythonPackage rec {
  pname = "pymsteams";
  version = "0.1.14";

  src = fetchFromGitHub {
    owner = "rveachkc";
    repo = pname;
    rev = version;
    sha256 = "19gnsjzf3kwcwp2rwa30zpqjqgxb9plgcsx7fqbmxnrxgw99fyqx";
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
