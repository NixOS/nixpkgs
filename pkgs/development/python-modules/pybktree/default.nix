{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "pybktree";
  version = "1.1";

  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    extension = "tar.gz";
    hash = "sha256-7sADfN09dVPm1yQ1pDeb7eZL4XxnEvFJ5IUWljgVTSs=";
  };

  meta = with lib; {
    description = "Generic, pure python implementation of a BK-tree data structure";
    homepage = "https://github.com/Jetsetter/pybktree";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ aehmlo ];
  };
}
