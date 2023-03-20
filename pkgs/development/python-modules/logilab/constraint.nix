{ lib, buildPythonPackage, fetchPypi, logilab-common, six }:

buildPythonPackage rec {
  pname = "logilab-constraint";
  version = "0.6.2";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Jk6wvvcDEeHfy7dUcjbnzFIeGBYm5tXzCI26yy+t2qs=";
  };

  propagatedBuildInputs = [
    logilab-common six
  ];


  meta = with lib; {
    description = "logilab-database provides some classes to make unified access to different";
    homepage = "https://www.logilab.org/project/logilab-database";
  };
}

