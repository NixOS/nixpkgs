{ lib
, buildPythonPackage
, fetchFromGitHub
, multiprocess
, pandas
, pandas-stubs
, poetry-core
, pydantic
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pandantic";
  version = "0.3.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "wesselhuising";
    repo = "pandantic";
    rev = "refs/tags/${version}";
    hash = "sha256-HSkk2d8oOuChxe2OXHCQ+Gm8Sb9KHoA8Llkk3QXl6co=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    multiprocess
    pandas
    pandas-stubs
    pydantic
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pandantic"
  ];

  meta = with lib; {
    description = "About
Enriches the Pydantic BaseModel class by adding the ability to validate dataframes using the schema and custom validators of the same BaseModel class.";
    homepage = "https://github.com/wesselhuising/pandantic";
    license = licenses.unfree;
    maintainers = with maintainers; [ yannip ];
  };
}
