{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "httpagentparser";
  version = "1.9.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a190dfdc5e63b2f1c87729424b19cbc49263d6a1fb585a16ac1c9d9ce127a4bf";
  };

  # PyPi version does not include test directory
  doCheck = false;

  pythonImportsCheck = [ "httpagentparser" ];

  meta = with lib; {
    homepage = "https://github.com/shon/httpagentparser";
    description = "Extracts OS Browser etc information from http user agent string";
    license = licenses.mit;
    maintainers = with maintainers; [ gador ];
  };
}
