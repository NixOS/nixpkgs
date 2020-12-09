{ buildPythonPackage, fetchPypi, lib, urllib3, pyee, tqdm, websockets, appdirs }:

buildPythonPackage rec {
  pname = "pyppeteer";
  version = "0.2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1s92izan7s3iffc85wpwi1qv9brcq0rlfqyi84wmpmg1dxk64g0m";
  };

  # tests want to write to /homeless-shelter
  doCheck = false;

  propagatedBuildInputs = [
    appdirs
    websockets
    tqdm
    pyee
    urllib3
  ];

  meta = {
    description = "Headless chrome/chromium automation library (unofficial port of puppeteer)";
    homepage = "https://github.com/pyppeteer/pyppeteer";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kmein ];
  };
}
