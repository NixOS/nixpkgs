{ lib
, buildPythonPackage
, fetchPypi
, requests
, future
, pyyaml
, jsonlines
}:

buildPythonPackage rec {
  pname = "cloudflare";
  version = "2.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0w8ihj9gram2d4wkbki8f6gr8hsd950b3wzfi1qqqm17lqfk8k7h";
  };

  propagatedBuildInputs = [
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
