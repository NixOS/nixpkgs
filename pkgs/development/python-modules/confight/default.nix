{ lib
, buildPythonPackage
, fetchFromGitHub
, toml
}:

buildPythonPackage rec {
  pname = "confight";
  version = "1.3.1";

  src = fetchFromGitHub {
     owner = "avature";
     repo = "confight";
     rev = "1.3.1";
     sha256 = "0flqn940yxaklg1v5wl07pfvfa8bqm6iv0sqvpfl7yzai08h1lsi";
  };

  propagatedBuildInputs = [
    toml
  ];

  pythonImportsCheck = [ "confight" ];

  doCheck = false;

  meta = with lib; {
    description = "Python context manager for managing pid files";
    homepage = "https://github.com/avature/confight";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ mkg20001 ];
  };
}
