{ lib, fetchPypi, buildPythonPackage, pythonOlder
, shapely }:

buildPythonPackage rec {
  pname = "preprocess-cancellation";
  version = "0.2.0";
  disabled = pythonOlder "3.6"; # >= 3.6

  src = fetchPypi {
    inherit version;
    pname = "preprocess_cancellation";
    hash = "sha256-62hJTjXAof6DcW8qFOErPhze35RYdSvhys4A+UTZB2A=";
  };

  propagatedBuildInputs = [ shapely ];

  pythonImportsCheck = [ "preprocess_cancellation" ];

  meta = with lib; {
    description = "Klipper GCode Preprocessor for Object Cancellation";
    homepage = "https://github.com/kageurufu/cancelobject-preprocessor";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ zhaofengli ];
  };
}
