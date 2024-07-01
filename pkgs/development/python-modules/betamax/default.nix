{
  lib,
  buildPythonPackage,
  fetchPypi,
  requests,
}:

buildPythonPackage rec {
  pname = "betamax";
  version = "0.9.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-gjFuFnm8aHnjyDMY0Ba1S3ySJf8IxEYt5IE+IgONX5Q=";
  };

  propagatedBuildInputs = [ requests ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://betamax.readthedocs.org/en/latest/";
    description = "VCR imitation for requests";
    license = licenses.asl20;
    maintainers = with maintainers; [ pSub ];
  };
}
