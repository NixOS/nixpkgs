{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "durationpy";
  version = "0.5";

  src = fetchPypi {
    inherit version pname;
    hash = "sha256-XvlBa1J7UNci80ZVvs+3Xkkijrgvh7hV7RkRszFLVAg=";
  };

  meta = with lib; {
    description = "Module for converting between datetime.timedelta and Go's Duration strings";
    homepage = "https://github.com/icholy/durationpy";
    license = licenses.mit;
  };
}
