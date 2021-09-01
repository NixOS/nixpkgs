{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "pyintesishome";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "jnimmo";
    repo = "pyIntesisHome";
    rev = version;
    sha256 = "1y1agdr32p7m4dbb6kzchh0vb49gy0rqp8hq9zadwrq2vp70k5sn";
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
