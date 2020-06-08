{ fetchFromGitHub, buildPythonPackage, python3Packages, lib, isPy3k }:

buildPythonPackage rec {
  pname = "csvw";
  version = "1.7.0";
  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "cldf";
    repo = "csvw";
    rev = "v${version}";
    sha256 = "0a6h9cakxhd6i32l83qvqn3vdzlv0x0vjmv8dqwlfawjdrqs7qm9";
  };

  propagatedBuildInputs = with python3Packages; [
    attrs
    isodate
    dateutil
    rfc3986
    uritemplate
  ];

  meta = with lib; {
    description = "CSV on the Web";
    homepage = "https://github.com/cldf/csvw";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
