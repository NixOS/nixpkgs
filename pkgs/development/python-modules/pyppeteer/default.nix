{ buildPythonPackage, fetchPypi, lib, urllib3, pyee, tqdm, websockets, appdirs }:

buildPythonPackage rec {
  pname = "pyppeteer";
  version = "0.2.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c2974be1afa13b17f7ecd120d265d8b8cd324d536a231c3953ca872b68aba4af";
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
