{ lib
, fetchFromGitHub
, flit-core
, python3Packages
, pythonOlder
}:

python3Packages.buildPythonPackage rec {
  pname = "aocd-example-parser";
  version = "unstable-2023-12-17";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "wimglenn";
    repo = "aocd-example-parser";
    rev = "07330183f3e43401444fe17b08d72eb6168504e1";
    hash = "sha256-iOxqzZj29aY/xyigir1KOU6GcBBvnlxEOBLHChEQjf4=";
  };

  propagatedBuildInputs = [
    flit-core
  ];

  doCheck = false; # tests need aocd which in turn require aocd-example-parser

  meta = with lib; {
    description = "Implementation of an aocd example parser plugin";
    homepage = "https://github.com/wimglenn/aocd-example-parser";
    license = licenses.mit;
    maintainers = with maintainers; [ rapiteanu ];
    platforms = platforms.unix;
  };
}
