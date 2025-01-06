{
  lib,
  requests,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "bizkaibus";
  version = "0.2.0";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "UgaitzEtxebarria";
    repo = "BizkaibusRTPI";
    rev = version;
    sha256 = "sha256-TM02pSSOELRGSwsKc5C+34W94K6mnS0C69aijsPqSWs=";
  };

  propagatedBuildInputs = [ requests ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "bizkaibus" ];

  meta = with lib; {
    description = "Python module to get information about Bizkaibus buses";
    homepage = "https://github.com/UgaitzEtxebarria/BizkaibusRTPI";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
