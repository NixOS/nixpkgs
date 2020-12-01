{ lib
, buildPythonPackage
, fetchPypi
, attrs
, pythonOlder
}:

buildPythonPackage rec {
  pname = "markdown-it-py";
  version = "0.5.6";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6143d11221495edbf71beb7e455821ae6c8f0156710a1b11812662ed6dbd165b";
  };

  propagatedBuildInputs = [
    attrs
  ];

  doCheck = false;

  meta = with lib; {
    description = "Python port of markdown-it. Markdown parsing, done right";
    homepage = https://github.com/executablebooks/markdown-it-py;
    license = licenses.mit;
  };
}