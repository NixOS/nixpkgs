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
  version = "2.6.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4463d5f2927338384169315f34c2a8ac0840075b59489f8d1d773b91caba6c39";
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
