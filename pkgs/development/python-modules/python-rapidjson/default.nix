{ stdenv
, buildPythonPackage
, fetchPypi
, pythonOlder
, pytest
, pytz
, glibcLocales
}:

buildPythonPackage rec {
  version = "0.9.1";
  pname = "python-rapidjson";
  disabled = pythonOlder "3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ad80bd7e4bb15d9705227630037a433e2e2a7982b54b51de2ebabdd1611394a1";
  };

  LC_ALL="en_US.utf-8";
  buildInputs = [ glibcLocales ];

  # buildInputs = [ ];
  checkInputs = [ pytest pytz ];
  # propagatedBuildInputs = [ ];

  checkPhase = ''
    pytest tests
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/python-rapidjson/python-rapidjson;
    description = "Python wrapper around rapidjson ";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
