{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  requests,
  vcrpy,
}:

buildPythonPackage rec {
  pname = "libpyvivotek";
  version = "0.6.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "HarlemSquirrel";
    repo = "python-vivotek";
    rev = "v${version}";
    sha256 = "sha256-ai+FlvyrdeLyg/PJU8T0fTtbdnlyGo6mE4AM2oRATj8=";
  };

  propagatedBuildInputs = [ requests ];

  nativeCheckInputs = [
    pytestCheckHook
    vcrpy
  ];

  pythonImportsCheck = [ "libpyvivotek" ];

  meta = with lib; {
    description = "Python Library for Vivotek IP Cameras";
    homepage = "https://github.com/HarlemSquirrel/python-vivotek";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
