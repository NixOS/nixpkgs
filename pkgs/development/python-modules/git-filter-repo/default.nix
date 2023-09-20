{ lib
, buildPythonPackage
, fetchpatch
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

  patches = [
    # https://github.com/newren/git-filter-repo/pull/498
    (fetchpatch {
      name = "remove-duplicate-script.patch";
      url = "https://github.com/newren/git-filter-repo/commit/a59e67e7918e577147ca36a70916741be029c878.patch";
      hash = "sha256-b0QHy9wMWuBWQoptdvLRT+9SRx2u2+11PnzEEB5F0Yo=";
      stripLen = 1;
    })
  ];

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
