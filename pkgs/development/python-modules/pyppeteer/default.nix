{ buildPythonPackage, fetchPypi, lib, urllib3, pyee, tqdm, websockets, appdirs }:

buildPythonPackage rec {
  pname = "pyppeteer";
  version = "0.2.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d1bcc61575ff788249d3bcaee696d856fa1153401a5428cb7376d826dd68dd9b";
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
