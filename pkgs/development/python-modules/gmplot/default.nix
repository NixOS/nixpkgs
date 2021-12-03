{ lib
, buildPythonApplication
, fetchFromGitHub
, requests
}:

buildPythonApplication rec {
  pname = "gmplot";
  version = "1.4.1";

  src = fetchFromGitHub {
    repo = pname;
    owner = "gmplot";
    rev = "80b421bd68faf43ec58549beefc817c7425ef80c";
    sha256 = "sha256-GSeXVvc0b8eH+qTJp1/3UhWAQL3Cdbqs3Y3lI7PdvXQ=";
  };

  propagatedBuildInputs = [ requests ];

  meta = with lib; {
    description = "A matplotlib-like interface to render all the data you'd like on top of Google Maps.";
    homepage = "https://github.com/gmplot/gmplot";
    license = licenses.mit;
    maintainers = with maintainers; [ nixinator ];
  };
}
