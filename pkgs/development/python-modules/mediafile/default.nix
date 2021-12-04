{ lib
, buildPythonPackage
, fetchPypi
, mutagen
, six
, pythonOlder
}:

buildPythonPackage rec {
  pname = "mediafile";
  version = "0.9.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-k8zvP7t9RVSg52idQSNs1WhqLy8XSTCYYiuDRM+D35o=";
  };

  propagatedBuildInputs = [
    mutagen
    six
  ];

  pythonImportsCheck = [
    "mediafile"
  ];

  meta = with lib; {
    description = "Python interface to the metadata tags for many audio file formats";
    homepage = "https://github.com/beetbox/mediafile";
    license = licenses.mit;
    maintainers = with maintainers; [ lovesegfault ];
  };
}
