{ lib
, buildPythonPackage
, fetchPypi
, hypothesis
, isPy27
, mock
, nose
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "dpath";
  version = "2.0.6";

  disabled = isPy27; # uses python3 imports

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Wh3a5SIz+8jvgbFfuFBzqBEmu0NpjT86G2qvVhpGzcA=";
  };

  # use pytest as nosetests hangs
  checkInputs = [
    hypothesis
    mock
    nose
    pytestCheckHook
  ];

  pythonImportsCheck = [ "dpath" ];

  meta = with lib; {
    description = "Python library for accessing and searching dictionaries via /slashed/paths ala xpath";
    homepage = "https://github.com/akesterson/dpath-python";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ mmlb ];
  };
}
