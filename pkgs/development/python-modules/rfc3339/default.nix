{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "rfc3339";
  version = "6.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-1Tw7Xu+u+JK3JAuiqR/vAS6G+qTQoMp4I1nEkOAK1NA=";
  };

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "rfc3339" ];

  meta = with lib; {
    description = "Format dates according to the RFC 3339";
    homepage = "https://hg.sr.ht/~henryprecheur/rfc3339";
    license = licenses.isc;
    maintainers = with maintainers; [ fab ];
  };
}
