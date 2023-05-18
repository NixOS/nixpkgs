{ buildPythonPackage
, lib
, fetchPypi
}:

buildPythonPackage rec {
  pname = "decli";
  version = "0.5.2";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8s3lUDSnXIGcYwx2VahExhLyWYxCwhKZFgRl32rUY60=";
  };

  pythonImportsCheck = [ "decli" ];

  meta = with lib; {
    description = "Minimal, easy to use, declarative command line interface tool";
    homepage = "https://github.com/Woile/decli";
    license = licenses.mit;
    maintainers = with maintainers; [ lovesegfault ];
  };
}
