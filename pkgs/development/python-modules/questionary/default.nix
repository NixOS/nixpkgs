{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry
, prompt-toolkit
, pytest-cov
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "questionary";
  version = "1.10.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "tmbo";
    repo = pname;
    rev = version;
    sha256 = "14k24fq2nmk90iv0k7pnmmdhmk8z261397wg52sfcsccyhpdw3i7";
  };

  nativeBuildInputs = [
    poetry
  ];

  propagatedBuildInputs = [
    prompt-toolkit
  ];

  checkInputs = [
    pytest-cov
    pytestCheckHook
  ];

  pythonImportsCheck = [ "questionary" ];

  meta = with lib; {
    description = "Python library to build command line user prompts";
    homepage = "https://github.com/tmbo/questionary";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
