{ fetchFromGitHub, buildPythonPackage, python3Packages, lib, isPy3k }:

buildPythonPackage rec {
  pname = "clldutils";
  version = "3.5.1";
  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "clld";
    repo = pname;
    rev = "v${version}";
    sha256 = "0sq4ii2faba8xgc88kc8mg0rlwnr8kfzsc49s1ki3nnqjdwzfnr6";
  };

  propagatedBuildInputs = with python3Packages; [
    dateutil
    tabulate
    colorlog
    attrs
    csvw
  ];

  meta = with lib; {
    description = "CSV on the Web";
    homepage = "https://github.com/cldf/csvw";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
