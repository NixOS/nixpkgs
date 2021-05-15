{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, requests
}:

buildPythonPackage rec {
  pname = "pynuki";
  version = "1.4.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "pschmitt";
    repo = pname;
    rev = version;
    sha256 = "1nymlrf0j430851plp355697p55asfxjmavdh2zr96b16d41dnn4";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [ requests ];

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "pynuki" ];

  meta = with lib; {
    description = "Python bindings for nuki.io bridges";
    homepage = "https://github.com/pschmitt/pynuki";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
