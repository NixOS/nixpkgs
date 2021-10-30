{ lib
, buildPythonPackage
, fetchFromGitHub
, pyserial
}:

buildPythonPackage rec {
  pname = "python-velbus";
  version = "2.1.4";

  src = fetchFromGitHub {
    owner = "thomasdelaet";
    repo = pname;
    rev = version;
    sha256 = "1z0a7fc9xfrcpwi9xiimxsgbzbp2iwyi1rij6vqd5z47mzi49fv9";
  };

  propagatedBuildInputs = [
    pyserial
  ];

  # Project has not tests
  doCheck = false;

  pythonImportsCheck = [ "velbus" ];

  meta = with lib; {
    description = "Python library to control the Velbus home automation system";
    homepage = "https://github.com/thomasdelaet/python-velbus";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
