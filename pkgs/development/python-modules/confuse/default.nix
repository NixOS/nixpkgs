{ buildPythonPackage
, enum34
, fetchPypi
, isPy27
, lib
, pathlib
, pyyaml
}:

buildPythonPackage rec {
  pname = "confuse";
  version = "1.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-kvwEUcbiwnMqw2PQ9Z1+pgir3b7QYt2o6Y6ajJhs5GQ=";
  };

  propagatedBuildInputs = [ pyyaml ] ++ lib.optionals isPy27 [ enum34 pathlib ] ;

  meta = with lib; {
    description = "Confuse is a configuration library for Python that uses YAML.";
    homepage = "https://github.com/beetbox/confuse";
    license = licenses.mit;
    maintainers = with maintainers; [ lovesegfault ];
  };
}
