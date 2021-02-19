{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, poetry
, pythonOlder
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "freebox-api";
  version = "0.0.9";
  format = "pyproject";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "hacf-fr";
    repo = pname;
    rev = "v${version}";
    sha256 = "0qn7jqfbp850aqgfsxjfv14myi6idz6sf7024p6wpqpa2xk0vfiq";
  };

  nativeBuildInputs = [ poetry ];

  propagatedBuildInputs = [ aiohttp ];

  checkInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "freebox_api" ];

  meta = with lib; {
    description = "Python module to interact with the Freebox OS API";
    homepage = "https://github.com/hacf-fr/freebox-api";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
