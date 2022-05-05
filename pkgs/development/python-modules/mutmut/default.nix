{ lib
, fetchFromGitHub
, buildPythonApplication
, click
, glob2
, parso
, pony
, junit-xml
, pythonOlder
, testers
}:

let self = buildPythonApplication rec {
  pname = "mutmut";
  version = "2.2.0";

  src = fetchFromGitHub {
    repo = pname;
    owner = "boxed";
    rev = version;
    hash = "sha256-G+OL/9km2iUeZ1QCpU73CIWVWMexcs3r9RdCnAsESnY=";
  };

  postPatch = ''
    substituteInPlace requirements.txt --replace 'junit-xml==1.8' 'junit-xml==1.9'
  '';

  disabled = pythonOlder "3.7";

  doCheck = false;

  propagatedBuildInputs = [ click glob2 parso pony junit-xml ];

  passthru.tests.version = testers.testVersion { package = self; };

  meta = with lib; {
    description = "mutation testing system for Python, with a strong focus on ease of use";
    homepage = "https://github.com/boxed/mutmut";
    changelog = "https://github.com/boxed/mutmut/blob/${version}/HISTORY.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ synthetica ];
  };
};
in self
