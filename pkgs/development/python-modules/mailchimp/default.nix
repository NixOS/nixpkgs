{ stdenv
, buildPythonPackage
, fetchPypi
, docopt
, requests
}:

buildPythonPackage rec {
  version = "2.0.9";
  pname = "mailchimp";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0351ai0jqv3dzx0xxm1138sa7mb42si6xfygl5ak8wnfc95ff770";
  };

  buildInputs = [ docopt ];
  propagatedBuildInputs = [ requests ];
  patchPhase = ''
    sed -i 's/==/>=/' setup.py
  '';

  meta = with stdenv.lib; {
    description = "A CLI client and Python API library for the MailChimp email platform";
    homepage = "http://apidocs.mailchimp.com/api/2.0/";
    license = licenses.mit;
  };

}
