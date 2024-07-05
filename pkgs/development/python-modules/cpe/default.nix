{ lib, stdenv, fetchFromGitHub, buildPythonPackage, pytest, pytestCheckHook
, setuptools, python3, sphinx }:

buildPythonPackage rec {
  pname = "cpe";
  version = "1.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nilp0inter";
    repo = "cpe";
    rev = "v${version}";
    hash = "sha256-1hTOMbsL1089/yPZbAIs5OgjtEzCBlFv2hGi+u4hV/k=";
  };

  build-system = [ setuptools ];

  dependencies = [ sphinx pytest ];

  pythonImportsCheck = [ "cpe" ];

  # no test
  doCheck = false;

  meta = {
    description = "Common platform enumeration for python";
    homepage = "https://github.com/nilp0inter/cpe";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ tochiaha ];
    platforms = lib.platforms.all;
  };
}

