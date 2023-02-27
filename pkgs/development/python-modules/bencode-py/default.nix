{
  lib,
  buildPythonPackage,
  fetchPypi,
  python,
  pbr,
  pytestCheckHook,
}:
buildPythonPackage rec {
  pname = "beconde-py";
  version = "4.0.0";
  format = "setuptools";

  src = fetchPypi {
    inherit version;
    pname = "bencode.py";
    sha256 = "sha256-KiTM2hclpRplCJPQtjJgE4NZ6qKZu256CZYTUKKm4Fw=";
  };

  pythonImportsCheck = [
    "bencodepy"
  ];

  nativeBuildInputs = [
    pbr
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Simple bencode parser (for Python 2, Python 3 and PyPy)";
    homepage = "https://github.com/fuzeman/bencode.py";
    license = licenses.bitTorrent11;
    maintainers = with maintainers; [vamega];
  };
}
