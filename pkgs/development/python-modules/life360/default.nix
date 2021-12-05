{ lib, buildPythonPackage, fetchFromGitHub, pytestCheckHook, pythonOlder
, requests }:

buildPythonPackage rec {
  pname = "life360";
  version = "4.1.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pnbruckner";
    repo = pname;
    rev = "v${version}";
    sha256 = "v+j0DBWQb1JdOu+uxJAdWhzef5zB62z+NSQ+WxpsinA=";
  };

  propagatedBuildInputs = [ requests ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "life360" ];

  meta = with lib; {
    description = "Python module to interact with Life360";
    homepage = "https://github.com/pnbruckner/life360";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
