{ stdenv
, buildPythonPackage
, fetchPypi
, pythonOlder
, importlib-metadata
}:

buildPythonPackage rec {
  pname = "catalogue";
  version = "2.0.0";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "34f8416ec5e7ed08e55c10414416e67c3f4d66edf83bc67320c3290775293816";
  };

  propagatedBuildInputs = [ importlib-metadata ];

  meta = with stdenv.lib; {
    description = "Tiny library for adding function or object registries";
    homepage = "https://github.com/explosion/catalogue";
    license = licenses.mit;
    maintainers = with maintainers; [ danieldk ];
    };
}
