{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytest,
}:

buildPythonPackage rec {
  pname = "backcall";
  version = "0.2.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XL2/J75efPrbRIuvCqlVCPkfK7xsZDfNnNBuKkwhXh4=";
  };

  nativeCheckInputs = [ pytest ];

  checkPhase = ''
    py.test
  '';

  meta = {
    description = "Specifications for callback functions passed in to an API";
    homepage = "https://github.com/takluyver/backcall";
    license = lib.licenses.bsd3;
  };
}
