{ lib
, buildPythonPackage
, fetchFromGitHub
, future
, pythonOlder
, pytz
}:

buildPythonPackage rec {
  pname = "nsapi";
  version = "3.0.5";
  format = "setuptools";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "aquatix";
    repo = "ns-api";
    rev = "v${version}";
    sha256 = "0i1zkvi4mrhkh1gxzpa54mq8mb76s9nf3jxxhpqia56nkq8f8krb";
  };

  propagatedBuildInputs = [
    future
    pytz
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "ns_api" ];

  meta = with lib; {
    description = "Python module to query routes of the Dutch railways";
    homepage = "https://github.com/aquatix/ns-api/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
