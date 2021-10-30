{ lib
, requests
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "aladdin-connect";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "shoejosh";
    repo = pname;
    rev = version;
    sha256 = "0nimd1nw1haxn8s2207fcrmpjyfp6nx97n560l6hzqyqqmf2d1d1";
  };

  propagatedBuildInputs = [
    requests
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "aladdin_connect" ];

  meta = with lib; {
    description = "Python library for interacting with Genie Aladdin Connect devices";
    homepage = "https://github.com/shoejosh/aladdin-connect";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
