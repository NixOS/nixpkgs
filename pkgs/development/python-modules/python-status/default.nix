{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "python-status";
  version = "1.0.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0lryrvmi04g7d38ilm4wfw717m0ddhylrzb5cm59lrp3ai3q572f";
  };

  # Project doesn't ship tests yet
  doCheck = false;

  pythonImportsCheck = [ "status" ];

<<<<<<< HEAD
  meta = {
    description = "HTTP Status for Humans";
    homepage = "https://github.com/avinassh/status/";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "HTTP Status for Humans";
    homepage = "https://github.com/avinassh/status/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
