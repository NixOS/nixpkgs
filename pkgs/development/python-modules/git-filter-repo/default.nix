{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "git-filter-repo";
  version = "2.38.0";
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/hdT4Y8L1tPJtXhoyAEa59BWpuurcGcGOWoV71MScl4=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "git_filter_repo"
  ];

  meta = with lib; {
    description = "Quickly rewrite git repository history";
    homepage = "https://github.com/newren/git-filter-repo";
    license = with licenses; [ mit /* or */ gpl2Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
