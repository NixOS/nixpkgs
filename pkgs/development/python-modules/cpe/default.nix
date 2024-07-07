{ lib, fetchFromGitHub, buildPythonPackage, sphinx, setuptools }:

buildPythonPackage rec {
  pname = "cpe";
  version = "1.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nilp0inter";
    repo = "cpe";
    rev = "refs/tags/v${version}";
    hash = "sha256-1hTOMbsL1089/yPZbAIs5OgjtEzCBlFv2hGi+u4hV/k=";
  };

  build-system = [ setuptools ];

  dependencies = [ sphinx ];

  pythonImportsCheck = [ "cpe" ];

  doCheck = false;

  meta = {
    description = "Common platform enumeration for python";
    homepage = "https://github.com/nilp0inter/cpe";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ tochiaha ];
  };
}
