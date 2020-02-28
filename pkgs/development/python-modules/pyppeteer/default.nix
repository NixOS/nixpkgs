{ lib
, buildPythonPackage
, fetchPypi
, urllib3
, pyee
}:

buildPythonPackage rec {
  pname = "pyppeteer";
  version = "0.0.25";

  src = fetchPypi {
    inherit pname version;
    sha256 = "51fe769b722a1718043b74d12c20420f29e0dd9eeea2b66652b7f93a9ad465dd";
  };

  propagatedBuildInputs = [
    urllib3
    pyee
  ];

  meta = with lib; {
    description = "Headless chrome/chromium automation library (unofficial port of puppeteer";
    homepage = https://github.com/miyakogi/pyppeteer;
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
