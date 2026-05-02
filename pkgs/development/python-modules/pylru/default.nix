{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
}:

buildPythonPackage rec {
  pname = "pylru";
  version = "1.2.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "jlhutch";
    repo = "pylru";
    rev = "v${version}";
    hash = "sha256-TShFfwcF1FfIORzv71hTL4RGAIFh5Dxb+J3mpe1ovn4=";
  };

  # Check with the next release if tests are ready
  doCheck = false;

  pythonImportsCheck = [ "pylru" ];

  meta = {
    description = "Least recently used (LRU) cache implementation";
    homepage = "https://github.com/jlhutch/pylru";
    license = lib.licenses.gpl2Only;
    maintainers = [ ];
  };
}
