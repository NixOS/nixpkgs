{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, setuptools
, setuptools-scm
, anyqt
, cachecontrol
, CommonMark
, dictdiffer
, docutils
, lockfile
, qasync
}:

buildPythonPackage rec {
  pname = "orange-canvas-core";
  version = "0.1.28";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "biolab";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-9ozjQQK6xJC1qf8tBWLEfnLMLH5Gdqv6ST7zwk6ox+0=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    anyqt
    cachecontrol
    CommonMark
    dictdiffer
    docutils
    lockfile
    qasync
  ];

  doCheck = false;

  pythonImportsCheck = [ "orangecanvas" ];

  meta = with lib; {
    description = "A framework for building graphical user interfaces for editing workflows";
    longDescription = ''
      It is a component used to build the Orange Canvas (http://orange.biolab.si) data-mining application
      (for which it was developed in the first place).
    '';
    homepage = "https://orangedatamining.com/";
    changelog = "https://github.com/biolab/orange-canvas-core/releases/tag/${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ totoroot ];
  };
}
