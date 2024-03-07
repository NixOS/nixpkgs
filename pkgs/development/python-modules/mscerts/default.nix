{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "mscerts";
  version = "2024.2.28";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ralphje";
    repo = "mscerts";
    rev = "refs/tags/${version}";
    hash = "sha256-ReUDpax4tvw4ZCH8zOipelIPtHi7BdgLHI/r3FNpo1c=";
  };

  # extras_require contains signify -> circular dependency

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "mscerts"
  ];

  meta = with lib; {
    description = "Makes the Microsoft Trusted Root Program's Certificate Trust Lists available in Python";
    homepage = "https://github.com/ralphje/mscerts";
    license = with licenses; [ mpl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
