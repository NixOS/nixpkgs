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
  version = "2.8.13";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a662990737d86984156a48f769e6528d947e90fd1561bb5e19d0036b59b9fd6f";
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
