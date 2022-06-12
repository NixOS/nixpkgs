{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, pytest
, pytz
, glibcLocales
}:

buildPythonPackage rec {
  version = "1.6";
  pname = "python-rapidjson";
  disabled = pythonOlder "3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-GJzxqWv5/NhtADYPFa12qDzgiJuK6NHLD9srKZXlocg=";
  };

  LC_ALL="en_US.utf-8";
  buildInputs = [ glibcLocales ];

  # buildInputs = [ ];
  checkInputs = [ pytest pytz ];
  # propagatedBuildInputs = [ ];

  checkPhase = ''
    pytest tests
  '';

  meta = with lib; {
    homepage = "https://github.com/python-rapidjson/python-rapidjson";
    description = "Python wrapper around rapidjson ";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
