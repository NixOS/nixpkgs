{ lib
, buildPythonPackage
, fetchPypi
, requests
, pyquery
, fake-useragent
, parse
, beautifulsoup4
, w3lib
, pyppeteer
, isPy27
}:

buildPythonPackage rec {
  pname = "requests-html";
  version = "0.10.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "7e929ecfed95fb1d0994bb368295d6d7c4d06b03fcb900c33d7d0b17e6003947";
  };

  propagatedBuildInputs = [
    requests
    pyquery
    fake-useragent
    parse
    beautifulsoup4
    w3lib
    pyppeteer
  ];

  meta = with lib; {
    description = "HTML Parsing for Humans";
    homepage = https://github.com/kennethreitz/requests-html;
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
