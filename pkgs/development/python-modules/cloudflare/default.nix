{ lib
, buildPythonPackage
, fetchPypi
, beautifulsoup4
, requests
, future
, pyyaml
, jsonlines
}:

buildPythonPackage rec {
  pname = "cloudflare";
  version = "2.8.14";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5787892fdee3a6408b4290de0371426ab778a7ebf44decad9d843cab1ef0a1ac";
  };

  propagatedBuildInputs = [
    beautifulsoup4
    requests
    future
    pyyaml
    jsonlines
  ];

  # no tests associated with package
  doCheck = false;
  pythonImportsCheck = [ "CloudFlare" ];

  meta = with lib; {
    description = "Python wrapper for the Cloudflare v4 API";
    homepage = "https://github.com/cloudflare/python-cloudflare";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
