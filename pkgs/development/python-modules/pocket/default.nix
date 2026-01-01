{
  lib,
  buildPythonPackage,
  fetchPypi,
  requests,
}:

buildPythonPackage rec {
  pname = "pocket";
  version = "0.3.6";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1fc9vc5nyzf1kzmnrs18dmns7nn8wjfrg7br1w4c5sgs35mg2ywh";
  };

  buildInputs = [ requests ];

<<<<<<< HEAD
  meta = {
    description = "Wrapper for the pocket API";
    homepage = "https://github.com/tapanpandita/pocket";
    license = lib.licenses.bsd3;
=======
  meta = with lib; {
    description = "Wrapper for the pocket API";
    homepage = "https://github.com/tapanpandita/pocket";
    license = licenses.bsd3;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
