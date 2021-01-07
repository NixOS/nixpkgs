{ lib, buildPythonPackage, fetchPypi, pytestCheckHook, pytest-benchmark, wasmer }:

buildPythonPackage rec {
  pname = "fastdiff";
  version = "0.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ai95vjchl4396zjl1b69xfqvn9kn1y7c40d9l0qxdss0pcx6fk2";
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
