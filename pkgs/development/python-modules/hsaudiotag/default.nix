{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
}:

buildPythonPackage rec {
  pname = "hsaudiotag";
  version = "1.1.1";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "15hgm128p8nysfi0jb127awga3vlj0iw82l50swjpvdh01m7rda8";
  };

  # no tests
  doCheck = false;

  meta = with lib; {
    description = "A pure Python library that lets one to read metadata from media files";
    homepage = "http://hg.hardcoded.net/hsaudiotag/";
    license = licenses.bsd3;
  };

}
