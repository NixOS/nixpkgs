{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, pytest
, pytz
, glibcLocales
}:

buildPythonPackage rec {
  version = "1.5";
  pname = "python-rapidjson";
  disabled = pythonOlder "3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "04323e63cf57f7ed927fd9bcb1861ef5ecb0d4d7213f2755969d4a1ac3c2de6f";
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
