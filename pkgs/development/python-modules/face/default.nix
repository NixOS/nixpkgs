{ stdenv, buildPythonPackage, fetchPypi, boltons, pytest }:

buildPythonPackage rec {
  pname = "face";
  version = "0.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0zdp5qlrhxf4dypvvd0zr7zxj2svkz9wblp37vgw01wvcy9b1ds7";
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
