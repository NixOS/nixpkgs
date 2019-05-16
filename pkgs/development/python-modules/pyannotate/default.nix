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
  version = "1.0.7";
  pname = "pyannotate";

  src = fetchPypi {
    inherit pname version;
    sha256 = "54e6035a8601248992e17734034e6555842c6ea9863f90c15d14fe76a184be07";
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
