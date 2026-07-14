{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  grandalf,
  matplotlib,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "crysp";
  version = "1.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "bdcht";
    repo = "crysp";
    rev = "v${version}";
    hash = "sha256-51SKS6OOXIFT1L3YICR6a4QGSz/rbB8V+Z0u0jMO474=";
  };

  propagatedBuildInputs = [
    grandalf
    matplotlib
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'pytest-runner'," ""
  '';

  pythonImportsCheck = [ "crysp" ];

  meta = {
    description = "Module that provides crypto-related facilities";
    homepage = "https://github.com/bdcht/crysp";
    license = with lib.licenses; [ gpl2Only ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
