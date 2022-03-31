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
  version = "2.9.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-S82MJyulhM6L8cO4akwv+3tdY5qhkNHZr3gROMmSFmU=";
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
