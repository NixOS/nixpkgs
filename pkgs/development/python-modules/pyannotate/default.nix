{ stdenv
, buildPythonPackage
, fetchPypi
, pythonOlder
, six
, mypy_extensions
, typing
, pytest
}:

buildPythonPackage rec {
  version = "1.0.6";
  pname = "pyannotate";

  src = fetchPypi {
    inherit pname version;
    sha256 = "dbdc2a26cbf45490a650e976ba45f99abe9ddbf0af5746307914e5ef419e325e";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ six mypy_extensions ]
    ++ stdenv.lib.optionals (pythonOlder "3.5") [ typing ];

  checkPhase = ''
    py.test
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/dropbox/pyannotate;
    description = "Auto-generate PEP-484 annotations";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
