{ stdenv
, buildPythonPackage
, fetchPypi
, importlib-metadata
}:

buildPythonPackage rec {
  pname = "catalogue";
  version = "0.0.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0m7xp85fg57wi1l1vdsq2k0b8dv5bnfccds33lb04z9vrds4l3jv";
  };

  propagatedBuildInputs = [ importlib-metadata ];

  meta = with stdenv.lib; {
    description = "Tiny library for adding function or object registries";
    homepage = "https://github.com/explosion/catalogue";
    license = licenses.mit;
    maintainers = with maintainers; [ danieldk ];
    };
}
