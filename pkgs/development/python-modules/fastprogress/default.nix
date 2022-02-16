{ lib
, buildPythonPackage
, fetchPypi
, numpy
, pythonOlder
}:

buildPythonPackage rec {
  pname = "fastprogress";
  version = "1.0.2";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-lga6RCUFo6RFgdY97dzlv/HfF6y9w3JS98PxvlLB0kM=";
  };

  propagatedBuildInputs = [ numpy ];

  # no real tests
  doCheck = false;
  pythonImportsCheck = [ "fastprogress" ];

  meta = with lib; {
    homepage = "https://github.com/fastai/fastprogress";
    description = "Simple and flexible progress bar for Jupyter Notebook and console";
    license = licenses.asl20;
    maintainers = with maintainers; [ ris ];
  };

}
