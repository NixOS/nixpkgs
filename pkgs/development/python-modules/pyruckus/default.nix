{ lib
, buildPythonPackage
, fetchFromGitHub
, pexpect
, python-slugify
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyruckus";
  version = "0.16";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "gabe565";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-SVE5BrCCQgCrhOC0CSGgbZ9TEY3iZ9Rp/xMUShPAxxM=";
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
