{ stdenv
, buildPythonPackage
, fetchPypi
, pythonOlder
, six
, mypy-extensions
, typing
, pytest
}:

buildPythonPackage rec {
  version = "1.2.0";
  pname = "pyannotate";

  src = fetchPypi {
    inherit pname version;
    sha256 = "16bm0mf7wxvy0lgmcs1p8n1ji8pnvj1jvj8zk3am70dkp825iv84";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ six mypy-extensions ]
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
