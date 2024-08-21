{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
}:

buildPythonPackage rec {
  pname = "jsonformatter";
  version = "0.3.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "MyColorfulDays";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-oK419J/MIxRT+1j/5Yklj1F+4d3wuMXR8IVqJAMKPNw=";
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
