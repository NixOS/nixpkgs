{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "quantile-python";
  version = "1.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-VYYp6IxJfvO5sQgTScGuamG1NZDjF3JCmP9UxnTbeWk=";
  };

  # package has no tests
  doCheck = false;

  pythonImportsCheck = [ "quantile" ];

  meta = with lib; {
    description = "Python Implementation of Graham Cormode and S. Muthukrishnan's Effective Computation of Biased Quantiles over Data Streams in ICDE'05";
    homepage = "https://github.com/matttproud/python_quantile_estimation";
    license = licenses.asl20;
    maintainers = with maintainers; [ mbalatsko ];
  };
}
