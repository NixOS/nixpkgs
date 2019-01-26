{ stdenv, fetchFromGitHub, buildPythonPackage,
  lxml, tzlocal, python-dateutil, pygments, future, requests-kerberos,
  defusedxml, cached-property, isodate, requests_ntlm, dnspython,
  psutil, requests-mock, pyyaml
}:

buildPythonPackage rec {
  pname = "exchangelib";
  version = "1.12.0";

  # tests are not present in the PyPI version
  src = fetchFromGitHub {
    owner = "ecederstrand";
    repo = pname;
    rev = "v${version}";
    sha256 = "003c4flgsz6my64qm3mf9cb3wfxw0480aj9glf9wdz7xkwaq2l43";
  };

  # one test is failing due to it trying to send a request to example.com
  patches = [ ./skip_failing_test.patch ];
  checkInputs = [ psutil requests-mock pyyaml ];
  propagatedBuildInputs = [
    lxml tzlocal python-dateutil pygments requests-kerberos
    future defusedxml cached-property isodate requests_ntlm dnspython ];

  meta = with stdenv.lib; {
    description = "Client for Microsoft Exchange Web Services (EWS)";
    homepage    = "https://github.com/ecederstrand/exchangelib";
    license     = licenses.bsd2;
    maintainers = with maintainers; [ catern ];
  };
}
