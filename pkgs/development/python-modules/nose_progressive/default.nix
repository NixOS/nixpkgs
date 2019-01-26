{ stdenv
, buildPythonPackage
, fetchPypi
, nose
, pillow
, blessings
, isPy3k
}:

buildPythonPackage rec {
  pname = "nose-progressive";
  version = "1.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0mfbjv3dcg23q0a130670g7xpfyvgza4wxkj991xxh8w9hs43ga4";
  };

  buildInputs = [ nose ];
  propagatedBuildInputs = [ pillow blessings ];

  # fails with obscure error
  doCheck = !isPy3k;

  meta = with stdenv.lib; {
    homepage = https://github.com/erikrose/nose-progressive;
    description = "A testrunner with a progress bar and smarter tracebacks";
    license = licenses.mit;
    maintainers = with maintainers; [ domenkozar ];
  };

}
