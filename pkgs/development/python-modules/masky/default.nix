{ lib
, asn1crypto
, buildPythonPackage
, colorama
, cryptography
, fetchFromGitHub
, impacket
, pyasn1
, pythonOlder
}:

buildPythonPackage rec {
  pname = "masky";
  version = "0.1.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Z4kSec";
    repo = "Masky";
    rev = "refs/tags/v${version}";
    hash = "sha256-awPPpdw6/zlVa7/DY1iafrbqIHJERN5+cfX1bTnCjl0=";
  };

  propagatedBuildInputs = [
    asn1crypto
    colorama
    cryptography
    impacket
    pyasn1
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "masky"
  ];

  meta = with lib; {
    description = "Library to remotely dump domain credentials";
    homepage = "https://github.com/Z4kSec/Masky";
    changelog = "https://github.com/Z4kSec/Masky/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ elasticdog ];
  };
}
