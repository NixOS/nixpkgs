{ buildPythonPackage, fetchFromGitHub, lib, six, pypblib, pytestCheckHook }:

buildPythonPackage rec {
  pname = "python-sat";
  version = "0.1.7.dev1";

  src = fetchFromGitHub {
    owner = "pysathq";
    repo = "pysat";
    rev = version;
    sha256 = "sha256-zGdgD+SgoMB7/zDQI/trmV70l91TB7OkDxaJ30W3dkI=";
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
