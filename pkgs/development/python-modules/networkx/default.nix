{ lib
, buildPythonPackage
, fetchPypi
, nose
, pytestCheckHook
, decorator
, setuptools
, pythonOlder
}:

buildPythonPackage rec {
  pname = "networkx";
  # upgrade may break sage, please test the sage build or ping @timokau on upgrade
  version = "2.8.2";
  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-rpnJsNNeW0pizxz+oB5bNjPY0C9KDq1paFtufeW4Xqs=";
  };

  propagatedBuildInputs = [ decorator setuptools ];
  checkInputs = [ nose pytestCheckHook ];

  meta = {
    homepage = "https://networkx.github.io/";
    description = "Library for the creation, manipulation, and study of the structure, dynamics, and functions of complex networks";
    license = lib.licenses.bsd3;
  };
}
