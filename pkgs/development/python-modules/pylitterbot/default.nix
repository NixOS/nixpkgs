{ lib
, authlib
, buildPythonPackage
, fetchFromGitHub
, httpx
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pylitterbot";
  version = "2021.2.5";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "natekspencer";
    repo = pname;
    rev = version;
    sha256 = "0705bxm0rlpgwg8my7z5pp6y362bs2j53zy1yslha0ya6cgx37g8";
  };

  propagatedBuildInputs = [
    authlib
    httpx
  ];

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "pylitterbot" ];

  meta = with lib; {
    description = "Python package for controlling a Litter-Robot";
    homepage = "https://github.com/natekspencer/pylitterbot";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
