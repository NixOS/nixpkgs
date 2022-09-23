{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "pyintesishome";
  version = "1.8.3";

  src = fetchFromGitHub {
    owner = "jnimmo";
    repo = "pyIntesisHome";
    rev = "refs/tags/${version}";
    sha256 = "sha256-PMRTRQYckqD8GRatyj7IMAiFPbi91HvX19Jwe28rIPg=";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "pyintesishome" ];

  meta = with lib; {
    description = "Python interface for IntesisHome devices";
    homepage = "https://github.com/jnimmo/pyIntesisHome";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
