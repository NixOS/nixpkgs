{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry
, prompt_toolkit
, pytest-cov
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "questionary";
  version = "1.9.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "tmbo";
    repo = pname;
    rev = version;
    sha256 = "1x748bz7l2r48031dj6vr6jvvac28pv6vx1bina4lz60h1qac1kf";
  };

  nativeBuildInputs = [ poetry ];

  propagatedBuildInputs = [ prompt_toolkit ];

  checkInputs = [
    pytest-cov
    pytestCheckHook
  ];

  pythonImportsCheck = [ "questionary" ];

  meta = with lib; {
    description = "Python library to build command line user prompts";
    homepage = "https://github.com/bachya/regenmaschine";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
