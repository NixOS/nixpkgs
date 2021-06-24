{ buildPythonPackage, fetchFromGitHub, lib, six, pypblib, pytestCheckHook }:

buildPythonPackage rec {
  pname = "python-sat";
  version = "0.1.6.dev6";

  src = fetchFromGitHub {
    owner = "pysathq";
    repo = "pysat";
    rev = version;
    sha256 = "1gckxhqkvzyw7pmwg8xzxq146jysqy0s23l5mjc3awm6swdij66y";
  };

  propagatedBuildInputs = [ six pypblib ];

  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Toolkit to provide interface for various SAT (without optional dependancy py-aiger-cnf)";
    homepage = "https://github.com/pysathq/pysat";
    license = licenses.mit;
    maintainers = [ maintainers.marius851000 ];
  };
}
