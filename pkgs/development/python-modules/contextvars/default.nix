{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, python
, pythonOlder
, setuptools
, immutables
# Test inputs
, pytest
}:

buildPythonPackage rec {
  pname = "contextvars";
  version = "2.4";
  format = "setuptools";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "MagicStack";
    repo = "contextvars";
    rev = "v${version}";
    hash = "sha256-66VgtTYf4e3+nnH3Xala5+ujIFoSxRWch7azXyLWinM=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    immutables
  ];

  nativeCheckInputs = [
    pytest
  ];

  checkPhase = ''
    runHook preCheck
    pytest tests/
    runHook postCheck
  '';

  doCheck = true;

  pythonImportsCheck = [ "contextvars" ];

  meta = with lib; {
    homepage = "https://github.com/MagicStack/contextvars";
    description = "This package implements a backport of Python 3.7 contextvars module";
    license = licenses.asl20;
    maintainers = with maintainers; [ nviets ];
    platforms = platforms.unix;
  };
}
