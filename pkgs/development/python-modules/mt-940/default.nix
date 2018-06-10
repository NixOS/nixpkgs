{ buildPythonPackage, stdenv, pytestrunner, pyyaml, pytest, enum34
, pytestpep8, pytestflakes,fetchFromGitHub, isPy3k, lib, glibcLocales
}:

buildPythonPackage rec {
  version = "4.10.0";
  pname = "mt940";

  src = fetchFromGitHub {
    owner = "WoLpH";
    repo = pname;
    rev = "v${version}";
    sha256 = "1dsf2di8rr0iw2vaz6dppalby3y7i8x2bl0qjqvaiqacjxxvwj65";
  };

  patches = [
    ./no-coverage.patch
  ];

  propagatedBuildInputs = [ pyyaml pytestrunner ]
    ++ lib.optional (!isPy3k) enum34;

  LC_ALL="en_US.UTF-8";

  checkInputs = [ pytestpep8 pytestflakes pytest glibcLocales ];
  checkPhase = ''
    py.test
  '';

  meta = with stdenv.lib; {
    description = "A library to parse MT940 files and returns smart Python collections for statistics and manipulation";
    homepage = "http://pythonhosted.org/mt-940/";
    license = licenses.bsd3;
  };
}
