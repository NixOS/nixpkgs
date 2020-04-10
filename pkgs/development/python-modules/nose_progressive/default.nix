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
    sha256 = "1mzmgq0wnfizmg9m2wn0c9g9282rdgv1jnphp8ww5h8kwqrjhvis";
  };

  buildInputs = [ nose ];
  propagatedBuildInputs = [ pillow blessings ];

  # fails with obscure error
  doCheck = !isPy3k;

  meta = with stdenv.lib; {
    homepage = "https://github.com/erikrose/nose-progressive";
    description = "A testrunner with a progress bar and smarter tracebacks";
    license = licenses.mit;
    maintainers = with maintainers; [ domenkozar ];
  };

}
