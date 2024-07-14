{
  lib,
  buildPythonPackage,
  fetchPypi,
  docopt,
  requests,
}:

buildPythonPackage rec {
  version = "2.0.10";
  format = "setuptools";
  pname = "mailchimp";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-UieZmQQjOn0unOXqxSJbml+sAxiuUQfj7QnIv4koZ2g=";
  };

  buildInputs = [ docopt ];
  propagatedBuildInputs = [ requests ];
  patchPhase = ''
    sed -i 's/==/>=/' setup.py
  '';

  meta = with lib; {
    description = "CLI client and Python API library for the MailChimp email platform";
    homepage = "http://apidocs.mailchimp.com/api/2.0/";
    license = licenses.mit;
  };
}
