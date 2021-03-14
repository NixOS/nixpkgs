{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytest-cov
, pytest-asyncio
, pytest-timeout
, responses
, pytestCheckHook
, requests
}:

buildPythonPackage rec {
  pname = "pyvera";
  version = "0.3.13";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "pavoni";
    repo = pname;
    rev = version;
    sha256 = "0vh82bwgbq93jrwi9q4da534paknpak8hxi4wwlxh3qcvnpy1njv";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [ requests ];

  checkInputs = [
    pytest-asyncio
    pytest-timeout
    pytest-cov
    pytestCheckHook
    responses
  ];

  pythonImportsCheck = [ "pyvera" ];

  meta = with lib; {
    description = "Python library to control devices via the Vera hub";
    homepage = "https://github.com/pavoni/pyvera";
    license = with licenses; [ gpl2Only ];
    maintainers = with maintainers; [ fab ];
  };
}
