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
  version = "1.0.6";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-LHQM+Vy8YVfTtpWaveYgBlp74AnS/IF3Y1EbgwVku7I=";
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
