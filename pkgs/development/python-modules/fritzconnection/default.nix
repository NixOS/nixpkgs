{ lib, buildPythonPackage, pythonOlder, fetchFromGitHub, pytestCheckHook, requests }:

buildPythonPackage rec {
  pname = "fritzconnection";
  version = "1.5.0";

  # no tests on PyPI
  src = fetchFromGitHub {
    owner = "kbr";
    repo = pname;
    rev = version;
    sha256 = "sha256-Iw7R+39rpoCTrRD74kBihF7AMcJWxy2xdPhKLznWdlo=";
  };

  disabled = pythonOlder "3.6";

  propagatedBuildInputs = [ requests ];

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "fritzconnection" ];

  meta = with lib; {
    description = "Python-Tool to communicate with the AVM Fritz!Box";
    homepage = "https://github.com/kbr/fritzconnection";
    changelog = "https://fritzconnection.readthedocs.io/en/${version}/sources/changes.html";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda valodim ];
  };
}
