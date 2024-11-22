{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
}:

buildPythonPackage rec {
  pname = "jsonformatter";
  version = "0.3.4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "MyColorfulDays";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-A+lsSBrm/64w7yMabmuAbRCLwUUdulGH3jB/DbYJ2QY=";
  };

  nativeBuildInputs = [ setuptools ];

  pythonImportsCheck = [ "jsonformatter" ];

  meta = with lib; {
    description = "jsonformatter is a formatter for python output json log, e.g. output LogStash needed log";
    homepage = "https://github.com/MyColorfulDays/jsonformatter";
    license = licenses.bsd2;
    maintainers = with maintainers; [ gador ];
  };
}
