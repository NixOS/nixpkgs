{ lib
, buildPythonPackage
, fetchPypi
, python-stdnum
}:
buildPythonPackage rec {
  pname = "barcodenumber";
  version = "0.5.0";
  format = "wheel";

  # Bitbucket repo is no longer public or does no longer exist
  src = fetchPypi {
    inherit pname version format;
    dist = "py3";
    python = "py3";
    hash = "sha256-VZfHLwSF9aDoy5L1x4O2mu8/f2ijYKgyjCrQ1KKY5Ho=";
  };

  propagatedBuildInputs = [
    python-stdnum
  ];

  pythonImportsCheck = [ "barcodenumber" ];

  meta = with lib; {
    description = "Python module to validate product codes";
    homepage = "https://pypi.org/project/barcodenumber/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ blaggacao ];
  };
}

