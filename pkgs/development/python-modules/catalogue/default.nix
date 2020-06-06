{ stdenv
, buildPythonPackage
, fetchPypi
, importlib-metadata
}:

buildPythonPackage rec {
  pname = "catalogue";
  version = "0.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1720242b2d0c11e666f9ceed39f0611236815b06af5421f7d8cbca48a4cff3af";
  };

  propagatedBuildInputs = [ importlib-metadata ];

  meta = with stdenv.lib; {
    description = "Tiny library for adding function or object registries";
    homepage = "https://github.com/explosion/catalogue";
    license = licenses.mit;
    maintainers = with maintainers; [ danieldk ];
    };
}
