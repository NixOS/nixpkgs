{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, tokenizers
}:

buildPythonPackage rec {
  pname = "rwkv";
  version = "0.7.4";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-35hoK+o0xE+Pcc3V7G/+c8rOpQL1Xwj3JbAU3oIHM+Y=";
  };

  propagatedBuildInputs = [
    setuptools
    tokenizers
  ];

  pythonImportsCheck = [ "rwkv" ];

  meta = with lib; {
    description = "The RWKV Language Model";
    homepage = "https://github.com/BlinkDL/ChatRWKV";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
