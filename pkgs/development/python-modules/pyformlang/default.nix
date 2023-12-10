{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, wheel
, networkx
, numpy
, pydot
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pyformlang";
  version = "1.0.4";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ysX6c8q26bcQyq6GgKBKxTdp00j+4ypb3mgM2cqCmBs=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    networkx
    numpy
    pydot
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pyformlang" ];

  meta = with lib; {
    description = "A python framework for formal grammars";
    homepage = "https://pypi.org/project/pyformlang/";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
  };
}
