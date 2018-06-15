{ stdenv, fetchPypi, fetchpatch
, buildPythonPackage, pythonOlder
, pytest, pytestrunner
, parse, six, enum34
}:

buildPythonPackage rec {
  pname = "parse_type";
  version = "0.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0g3b6gsdwnm8dpkh2vn34q6dzxm9gl908ggyzcv31n9xbp3vv5pm";
  };

  checkInputs = [ pytest pytestrunner ];
  propagatedBuildInputs = [ parse six ] ++ stdenv.lib.optional (pythonOlder "3.4") enum34;

  checkPhase = ''
    py.test tests
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/jenisys/parse_type;
    description = "Simplifies to build parse types based on the parse module";
    license = licenses.bsd3;
    maintainers = with maintainers; [ alunduil ];
  };
}
