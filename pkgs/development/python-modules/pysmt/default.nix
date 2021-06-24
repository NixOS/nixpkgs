{ lib
, buildPythonPackage
, fetchFromGitHub
, nose
, pytestCheckHook
, six
}:

buildPythonPackage rec {
  pname = "pysmt";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "051j36kpz11ik9bhvp5jgxzc3h7f18i1pf5ssdhjwyabr0n0zra3";
  };

  propagatedBuildInputs = [ six ];

  checkInputs = [
    nose
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pysmt" ];

  meta = with lib; {
    description = "Python library for SMT formulae manipulation and solving";
    homepage = "https://github.com/pysmt/pysmt";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
