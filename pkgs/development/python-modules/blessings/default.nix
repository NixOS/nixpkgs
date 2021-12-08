{ lib
, buildPythonPackage
, fetchFromGitHub
, six
, nose
}:

buildPythonPackage rec {
  pname = "blessings";
  version = "1.7";

  src = fetchFromGitHub {
     owner = "erikrose";
     repo = "blessings";
     rev = "1.7";
     sha256 = "0g6fqywhkww5pqgyxwmlahj0g0lh96vph0qm2661mmf788nbyc7y";
  };

  # 4 failing tests, 2to3
  doCheck = false;

  propagatedBuildInputs = [ six ];
  checkInputs = [ nose ];

  checkPhase = ''
    nosetests
  '';

  meta = with lib; {
    homepage = "https://github.com/erikrose/blessings";
    description = "A thin, practical wrapper around terminal coloring, styling, and positioning";
    license = licenses.mit;
    maintainers = with maintainers; [ domenkozar ];
  };

}
