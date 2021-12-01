{ buildPythonPackage, pythonAtLeast, pytest, requests, requests_oauthlib, six
, fetchFromGitHub, responses, lib
}:

buildPythonPackage rec {
  pname = "asana";
  version = "0.10.3";

  # upstream reportedly doesn't support 3.7 yet, blocked on
  # https://bugs.python.org/issue34226
  disabled = pythonAtLeast "3.7";

  src = fetchFromGitHub {
    owner = "asana";
    repo = "python-asana";
    rev = "v${version}";
    sha256 = "11nsfygcfpc2qb2gy4npi9w00cqfh88g7k3rsfq7xambz1zjdz1n";
  };

  checkInputs = [ pytest responses ];
  propagatedBuildInputs = [ requests requests_oauthlib six ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "requests_oauthlib >= 0.8.0, == 0.8.*" "requests_oauthlib>=0.8.0<2.0"
  '';

  checkPhase = ''
    py.test tests
  '';

  meta = with lib; {
    description = "Python client library for Asana";
    homepage = "https://github.com/asana/python-asana";
    license = licenses.mit;
  };
}
