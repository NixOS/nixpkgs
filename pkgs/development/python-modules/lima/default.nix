{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPy3k,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "lima";
  version = "0.5";
  format = "setuptools";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-OxBBmzZGM+PtpSw5ixIMVH/Z1YVOTO/ZvPecPAoAEmM=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Lightweight Marshalling of Python 3 Objects";
    homepage = "https://github.com/b6d/lima";
    license = licenses.mit;
    maintainers = with maintainers; [ zhaofengli ];
  };
}
