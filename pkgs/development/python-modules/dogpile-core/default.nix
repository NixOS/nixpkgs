{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "dogpile-core";
  version = "0.4.1";

  src = fetchPypi {
    pname = "dogpile.core";
    inherit version;
    sha256 = "0xpdvg4kr1isfkrh1rfsh7za4q5a5s6l2kf9wpvndbwf3aqjyrdy";
  };

  doCheck = false;

  pythonImportsCheck = [ "dogpile.core" ];

  meta = with lib; {
    description = "A 'dogpile' lock, typically used as a component of a larger caching solution";
    homepage = "https://bitbucket.org/zzzeek/dogpile.core";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
