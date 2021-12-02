{ stdenv, lib, buildPythonPackage, fetchPypi, wasmer, wasmer-compiler-cranelift, pytestCheckHook, pytest-benchmark }:

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
    substituteInPlace setup.cfg \
      --replace "collect_ignore = ['setup.py']" ""
  '';

  propagatedBuildInputs = [ wasmer wasmer-compiler-cranelift ];

  checkInputs = [ pytestCheckHook pytest-benchmark ];

  pythonImportsCheck = [ "fastdiff" ];

  meta = with lib; {
    description = "A fast native implementation of diff algorithm with a pure Python fallback";
    homepage = "https://github.com/syrusakbary/fastdiff";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
    # resulting compiled object panics at import
    broken = stdenv.is32bit;
  };
}
