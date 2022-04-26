{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "nest-asyncio";
  version = "1.5.5";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "erdewit";
    repo = "nest_asyncio";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-gk29RZhWIaBfiCtOC64rgP/KNqpxQadYbOj7IshN7RA=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "nest_asyncio"
  ];

  meta = with lib; {
    description = "Patch asyncio to allow nested event loops";
    homepage = "https://github.com/erdewit/nest_asyncio";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ costrouc ];
  };
}
