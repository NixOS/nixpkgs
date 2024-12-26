{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "msgspec";
  version = "0.18.6";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "jcrist";
    repo = "msgspec";
    rev = "refs/tags/${version}";
    hash = "sha256-xqtV60saQNINPMpOnZRSDnicedPSPBUQwPSE5zJGrTo=";
  };

  patches = [
    (fetchpatch2 {
      name = "python-3.13-compat.patch";
      url = "https://github.com/jcrist/msgspec/commit/7ade46952adea22f3b2bb9c2b8b3139e4f2831b7.patch";
      includes = [
        "msgspec/_core.c"
        "msgspec/_utils.py"
      ];
      hash = "sha256-yYotfJXUOaFiqvy0u+LqAx2YYnibNDXA24cE1ibPSOc=";
    })
  ];

  build-system = [ setuptools ];

  # Requires libasan to be accessible
  doCheck = false;

  pythonImportsCheck = [ "msgspec" ];

  meta = with lib; {
    description = "Module to handle JSON/MessagePack";
    homepage = "https://github.com/jcrist/msgspec";
    changelog = "https://github.com/jcrist/msgspec/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
