{ lib, stdenv
, buildPythonPackage
, fetchPypi
, pythonOlder
, pytest
, pytz
, glibcLocales
}:

buildPythonPackage rec {
  version = "0.9.4";
  pname = "python-rapidjson";
  disabled = pythonOlder "3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d79a412d7df30f01d3cb12e0e8863a48cfecd2fd7612719e16bc76eb1b65b332";
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
