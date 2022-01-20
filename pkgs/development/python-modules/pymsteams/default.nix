{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "pymsteams";
  version = "0.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "rveachkc";
    repo = pname;
    rev = version;
    sha256 = "1q4fm9dwnx5cy8r6gfzbn2f05hacpjfqlsgcyf2cv56wzb9rrg8v";
  };

  propagatedBuildInputs = [
    requests
  ];

  # Tests require network access
  doCheck = false;

  pythonImportsCheck = [
    "pymsteams"
  ];

  meta = with lib; {
    description = "Python module to interact with Microsoft Teams";
    homepage = "https://github.com/rveachkc/pymsteams";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
