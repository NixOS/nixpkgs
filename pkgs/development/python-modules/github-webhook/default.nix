{ lib, buildPythonPackage, fetchPypi
, flask
, six
}:

buildPythonPackage rec {
  pname = "github-webhook";
  version = "1.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "04jdf595gv97s4br0ym8izca3i6d1nfwcrpi4s26hkvn3czz84sv";
  };

  propagatedBuildInputs = [ flask six ];

  # touches network
  doCheck = false;

  meta = with lib; {
    description = "A framework for writing webhooks for GitHub";
    homepage = "https://github.com/bloomberg/python-github-webhook";
    license = licenses.mit;
  };
}
