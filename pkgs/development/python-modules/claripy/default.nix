{ lib
, buildPythonPackage
, cachetools
, decorator
, fetchFromGitHub
, future
, nose
, pysmt
, pythonOlder
, pytestCheckHook
, z3
}:

buildPythonPackage rec {
  pname = "claripy";
  version = "9.0.9355";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "angr";
    repo = pname;
    rev = "v${version}";
    sha256 = "1hmxkrzyhrc75z5d2ndf0z8icddrsd278lg640ihdjv1wabsa76w";
  };

  # Use upstream z3 implementation
  postPatch = ''
    substituteInPlace setup.py --replace "z3-solver>=4.8.5.0" ""
  '';

  propagatedBuildInputs = [
    cachetools
    decorator
    future
    pysmt
    z3
  ];

  checkInputs = [
    nose
    pytestCheckHook
  ];

  pythonImportsCheck = [ "claripy" ];

  meta = with lib; {
    description = "Python abstraction layer for constraint solvers";
    homepage = "https://github.com/angr/claripy";
    license = with licenses; [ bsd2 ];
    maintainers = with maintainers; [ fab ];
  };
}
