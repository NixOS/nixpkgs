{ lib
, buildPythonPackage
, fetchFromGitHub
, pexpect
, python-slugify
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyruckus";
  version = "0.14";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "gabe565";
    repo = pname;
    rev = version;
    sha256 = "069asvx7g2gywpmid0cbf84mlzhgha4yqd47y09syz09zgv34a36";
  };

  propagatedBuildInputs = [
    pexpect
    python-slugify
  ];

  # Tests requires network features
  doCheck = false;
  pythonImportsCheck = [ "pyruckus" ];

  meta = with lib; {
    description = "Python client for Ruckus Unleashed";
    homepage = "https://github.com/gabe565/pyruckus";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
