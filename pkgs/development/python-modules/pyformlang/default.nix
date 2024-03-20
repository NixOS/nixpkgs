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
  version = "1.0.9";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-oCwYM4yQ1KYZpC7vVpeHSIDH2Q930JAuTDq9mds9zoc=";
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

  pythonImportsCheck = [
    "pyformlang"
  ];

  meta = with lib; {
    description = "A python framework for formal grammars";
    homepage = "https://github.com/Aunsiels/pyformlang";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
  };
}
