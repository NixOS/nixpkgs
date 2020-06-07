{ stdenv
, buildPythonPackage
, fetchPypi
, importlib-metadata
}:

buildPythonPackage rec {
  pname = "catalogue";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d74d1d856c6b36a37bf14aa6dbbc27d0582667b7ab979a6108e61a575e8723f5";
  };

  propagatedBuildInputs = [ importlib-metadata ];

  meta = with stdenv.lib; {
    description = "Tiny library for adding function or object registries";
    homepage = "https://github.com/explosion/catalogue";
    license = licenses.mit;
    maintainers = with maintainers; [ danieldk ];
    };
}