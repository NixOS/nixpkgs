{ lib, aiohttp, buildPythonPackage, fetchFromGitLab, pythonOlder }:

buildPythonPackage rec {
  pname = "pynina";
  version = "unstable-2021-11-11";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitLab {
    owner = "DeerMaximum";
    repo = pname;
    rev = "0ac42b28d48af7bcd9c83f5d425b5b23c4c19f02";
    sha256 = "FSrFCs/4tfYcSPz9cgR+LFsRbWIHE1X+ZUl8BWSEaWQ=";
  };

  propagatedBuildInputs = [ aiohttp ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "pynina" ];

  meta = with lib; {
    description =
      "Python API wrapper to retrieve warnings from the german NINA app";
    homepage = "https://gitlab.com/DeerMaximum/pynina";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
