{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "httpagentparser";
  version = "1.9.3";

  # Github version does not have any release tags
  src = fetchPypi {
    inherit pname version;
    sha256 = "1x20j4gyx4vfsxs3bx8qcbdhq7n34gjr8gd01qlri96wpmn4c3rp";
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
