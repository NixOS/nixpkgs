{ lib
, buildPythonPackage
, docutils
, fetchFromGitHub
, isPy27
, nose
, pytest
}:

buildPythonPackage rec {
  version = "1.0.10";
  pname = "python_toolbox";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "cool-RR";
    repo = pname;
    rev = version;
    sha256 = "1hpls1hwisdjx1g15cq052bdn9fvh43r120llws8bvgvj9ivnaha";
  };

  checkInputs = [
    docutils
    pytest
  ];

  meta = with lib; {
    description = "Tools for testing PySnooper";
    homepage = "https://github.com/cool-RR/python_toolbox";
    license = licenses.mit;
    maintainers = with maintainers; [ seqizz ];
  };
}
