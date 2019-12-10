{ stdenv
, buildPythonPackage
, fetchPypi
, importlib-metadata
}:

buildPythonPackage rec {
  pname = "catalogue";
  version = "0.0.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c407a51c22f51b0f938104b6396c489145bae234386e68eb1d56326c3b3e128e";
  };

  propagatedBuildInputs = [ importlib-metadata ];

  meta = with stdenv.lib; {
    description = "Tiny library for adding function or object registries";
    homepage = "https://github.com/explosion/catalogue";
    license = licenses.mit;
    maintainers = with maintainers; [ danieldk ];
    };
}
