{ lib
, buildPythonPackage
, fetchPypi
, docutils
}:

buildPythonPackage rec {
  pname = "Pygments";
  version = "2.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5ffada19f6203563680669ee7f53b64dabbeb100eb51b61996085e99c03b284a";
  };

  propagatedBuildInputs = [ docutils ];

  # Circular dependency with sphinx
  doCheck = false;

  meta = {
    homepage = http://pygments.org/;
    description = "A generic syntax highlighter";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ ];
  };
}
