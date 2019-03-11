{ stdenv
, buildPythonPackage
, fetchFromGitHub
, pytest
, six
, enum34
, pathlib
, ordereddict
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyScss";
  version = "1.3.5";

  src = fetchFromGitHub {
    sha256 = "0lfsan74vcw6dypb196gmbprvlbran8p7w6czy8hyl2b1l728mhz";
    rev = "v1.3.5";
    repo = "pyScss";
    owner = "Kronuz";
  };

  checkInputs = [ pytest ];

  propagatedBuildInputs = [ six ]
    ++ (stdenv.lib.optionals (pythonOlder "3.4") [ enum34 pathlib ])
    ++ (stdenv.lib.optionals (pythonOlder "2.7") [ ordereddict ]);

  checkPhase = ''
    py.test
  '';

  meta = with stdenv.lib; {
    description = "A Scss compiler for Python";
    homepage = http://pyscss.readthedocs.org/en/latest/;
    license = licenses.mit;
  };

}
