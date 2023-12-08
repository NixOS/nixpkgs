{ lib, buildPythonPackage, fetchPypi
, mock, pytest, pytest-mock, pytest-server-fixtures, pytest-localserver
, termcolor, click, markdown2, six, jsonref, pyyaml, xmltodict, attrs
}:

buildPythonPackage rec {
  pname = "ramlfications";
  version = "0.1.9";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0xvnna7kaq4nm5nfnwcwbr5bcm2s532hgyp7kq4v9iivn48rrf3v";
  };

  meta = with lib; {
    description = "A Python RAML parser.";
    homepage    = "https://ramlfications.readthedocs.org";
    license     = licenses.asl20;
    maintainers = with maintainers; [ ];
    platforms   = platforms.all;
  };

  doCheck = false;
  # [darwin]  AssertionError: Expected 'update_mime_types' to have been called once. Called 0 times.

  buildInputs = [ mock pytest pytest-mock pytest-server-fixtures pytest-localserver ];

  propagatedBuildInputs = [ termcolor click markdown2 six jsonref pyyaml xmltodict attrs ];
}
