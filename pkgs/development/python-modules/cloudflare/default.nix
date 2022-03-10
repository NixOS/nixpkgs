{ lib
, buildPythonPackage
, fetchPypi
, attrs
, beautifulsoup4
, requests
, future
, pyyaml
, jsonlines
}:

buildPythonPackage rec {
  pname = "cloudflare";
  version = "2.8.15";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1f47bd324f80e91487dea2c79be934b1dc612bcfa63e784dcf74c6a2f52a41cc";
  };

  propagatedBuildInputs = [
    attrs
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
