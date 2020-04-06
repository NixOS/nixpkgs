{ pkgs
, buildPythonPackage
, requests
, six
}:

buildPythonPackage {
  version = "2016-01-04";
  pname = "dopy";

  src = pkgs.fetchFromGitHub {
    owner = "Wiredcraft";
    repo = "dopy";
    rev = "cb443214166a4e91b17c925f40009ac883336dc3";
    sha256 ="0ams289qcgna96aak96jbz6wybs6qb95h2gn8lb4lmx2p5sq4q56";
  };

  propagatedBuildInputs = [ requests six ];

  meta = with pkgs.lib; {
    description = "Digital Ocean API python wrapper";
    homepage = "https://github.com/Wiredcraft/dopy";
    license = licenses.mit;
    maintainers = with maintainers; [ lihop ];
  };
}
