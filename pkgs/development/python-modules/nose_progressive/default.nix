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
  version = "1.5.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3a6e2833e613c1c239baf05a19f66b5920915e62c07251d3ab3f3acb017ef5d7";
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
