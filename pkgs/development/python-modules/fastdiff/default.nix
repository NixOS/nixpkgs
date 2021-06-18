{ lib, buildPythonPackage, fetchPypi, pytestCheckHook, pytest-benchmark, wasmer }:

buildPythonPackage rec {
  pname = "fastdiff";
  version = "0.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4dfa09c47832a8c040acda3f1f55fc0ab4d666f0e14e6951e6da78d59acd945a";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'pytest-runner' ""
  '';

  propagatedBuildInputs = [ wasmer ];

  checkInputs = [ pytestCheckHook pytest-benchmark ];

  pythonImportsCheck = [ "fastdiff" ];
  disabledTests = [ "test_native" ];

  meta = with lib; {
    description = "A fast native implementation of diff algorithm with a pure Python fallback";
    homepage = "https://github.com/syrusakbary/fastdiff";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
