{ lib, buildPythonPackage, fetchPypi, logilab_common, six }:

buildPythonPackage rec {
  pname = "logilab-constraint";
  version = "0.6.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Jk6wvvcDEeHfy7dUcjbnzFIeGBYm5tXzCI26yy+t2qs=";
  };

  propagatedBuildInputs = [
    logilab_common six
  ];


  meta = with lib; {
    description = "logilab-database provides some classes to make unified access to different";
    homepage = "https://www.logilab.org/project/logilab-database";
  };
}

