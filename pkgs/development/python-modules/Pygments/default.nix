{ lib
, buildPythonPackage
, fetchPypi
, docutils
, isPy3k
}:

buildPythonPackage rec {
  pname = "Pygments";
  version = "2.6.1";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0i4gnd4q0mgkq0dp5wymn7ca8zjd8fgp63139svs6jf2c6h48wv4";
  };

  propagatedBuildInputs = [ docutils ];

  # Circular dependency with sphinx
  doCheck = false;

  meta = {
    homepage = "https://pygments.org/";
    description = "A generic syntax highlighter";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ ];
  };
}
