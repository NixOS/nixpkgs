{
  lib,
  requests,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "bizkaibus";
  version = "0.1.4";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "UgaitzEtxebarria";
    repo = "BizkaibusRTPI";
    rev = version;
    sha256 = "1v7k9fclndb4x9npzhzj68kbrc3lb3wr6cwal2x46ib207593ckr";
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
