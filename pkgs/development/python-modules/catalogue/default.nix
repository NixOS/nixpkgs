{ stdenv
, buildPythonPackage
, fetchPypi
, importlib-metadata
}:

buildPythonPackage rec {
  pname = "catalogue";
  version = "0.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0zha0gzqfkazc9da0cyjys5ghf20ihyhkgd1h5zxkxlf8zhz03s3";
  };

  propagatedBuildInputs = [ importlib-metadata ];

  meta = with stdenv.lib; {
    description = "Tiny library for adding function or object registries";
    homepage = "https://github.com/explosion/catalogue";
    license = licenses.mit;
    maintainers = with maintainers; [ danieldk ];
    };
}
