{ lib, buildPythonPackage, sphinx, fetchPypi }:

buildPythonPackage rec {
  pname = "guzzle-sphinx-theme";
  version = "0.7.11";
  src = fetchPypi {
    inherit pname version;
    sha256 = "1rnkzrrsbnifn3vsb4pfaia3nlvgvw6ndpxp7lzjrh23qcwid34v";
  };

  doCheck = false; # no tests

  propagatedBuildInputs = [ sphinx ];

  meta = with lib; {
    description = "Sphinx theme used by Guzzle: http://guzzlephp.org";
    homepage = "https://github.com/guzzle/guzzle-sphinx-theme/";
    license = licenses.mit;
    maintainers = with maintainers; [ flokli ];
    platforms = platforms.unix;
  };
}
