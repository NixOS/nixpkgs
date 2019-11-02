{ stdenv, buildPythonPackage, fetchPypi, boltons, pytest }:

buildPythonPackage rec {
  pname = "face";
  version = "19.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "38c94ec17a4d6f9628f094b697faca0f802f4028071ce8cbdb3116d4cde772a3";
  };

  propagatedBuildInputs = [ boltons ];

  checkInputs = [ pytest ];
  checkPhase = "pytest face/test";

  # ironically, test_parse doesn't parse, but fixed in git so no point
  # reporting
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/mahmoud/face;
    description = "A command-line interface parser and framework";
    longDescription = ''
      A command-line interface parser and framework, friendly for
      users, full-featured for developers.
    '';
    license = licenses.bsd3;
    maintainers = with maintainers; [ twey ];
  };
}
