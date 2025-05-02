{ pkgs
, buildPythonPackage
, requests
, six
}:

buildPythonPackage {
  pname = "dopy";
  version = "2016-01-04";
  format = "setuptools";

  src = pkgs.fetchFromGitHub {
    owner = "Wiredcraft";
    repo = "dopy";
    rev = "cb443214166a4e91b17c925f40009ac883336dc3";
    sha256 = "0ams289qcgna96aak96jbz6wybs6qb95h2gn8lb4lmx2p5sq4q56";
  };

  propagatedBuildInputs = [ requests six ];

  # contains no tests
  doCheck = false;
  pythonImportsCheck = [ "dopy" ];

  meta = with pkgs.lib; {
    description = "Digital Ocean API python wrapper";
    homepage = "https://github.com/Wiredcraft/dopy";
    license = licenses.mit;
    maintainers = with maintainers; [ lihop ];
  };
}
