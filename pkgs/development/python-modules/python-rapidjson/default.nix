{ stdenv
, buildPythonPackage
, fetchPypi
, pythonOlder
, pytest
, pytz
, glibcLocales
}:

buildPythonPackage rec {
  version = "0.9.3";
  pname = "python-rapidjson";
  disabled = pythonOlder "3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4e339edfbba9e5feed0cf44043b6befba0c780b34cdf446888dbce44de362a8a";
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
    homepage = "https://github.com/python-rapidjson/python-rapidjson";
    description = "Python wrapper around rapidjson ";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
