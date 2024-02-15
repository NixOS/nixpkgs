{ lib
, bash
, buildPythonPackage
, fetchFromGitHub
, fsspec
, pkgs
, pytestCheckHook
, pythonOlder
, setuptools
, setuptools-scm
, xrootd
}:

buildPythonPackage rec {
  pname = "fsspec-xrootd";
  version = "0.2.4";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "CoffeaTeam";
    repo = "fsspec-xrootd";
    rev = "refs/tags/v${version}";
    hash = "sha256-8TT+49SF/3i2OMIDcDD0AXEn0J9UkNX2q/SBkfoMXso=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    fsspec
    xrootd
  ];

  nativeCheckInputs = [
    pkgs.xrootd
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "fsspec_xrootd"
  ];

  meta = with lib; {
    description = "An XRootD implementation for fsspec";
    homepage = "https://github.com/CoffeaTeam/fsspec-xrootd";
    changelog = "https://github.com/CoffeaTeam/fsspec-xrootd/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
