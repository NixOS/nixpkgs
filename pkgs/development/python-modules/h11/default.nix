{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "h11";
  version = "0.12.0";

  src = fetchFromGitHub {
     owner = "python-hyper";
     repo = "h11";
     rev = "v0.12.0";
     sha256 = "16hxhk588im1d9bpgmvsjyg732zbq5hvz5xbmb19jnxdf2rkig7l";
  };

  checkInputs = [ pytestCheckHook ];

  # Some of the tests use localhost networking.
  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Pure-Python, bring-your-own-I/O implementation of HTTP/1.1";
    homepage = "https://github.com/python-hyper/h11";
    license = licenses.mit;
  };
}
