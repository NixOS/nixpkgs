{ lib, buildPythonPackage, fetchPypi, boltons, pytest }:

buildPythonPackage rec {
  pname = "face";
  version = "22.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-1daS+QvI9Zh7Y25H42OEubvaSZqvCneqCwu+g0x2kj0=";
  };

  propagatedBuildInputs = [ boltons ];

  checkInputs = [ pytest ];
  checkPhase = "pytest face/test";

  # ironically, test_parse doesn't parse, but fixed in git so no point
  # reporting
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/mahmoud/face";
    description = "A command-line interface parser and framework";
    longDescription = ''
      A command-line interface parser and framework, friendly for
      users, full-featured for developers.
    '';
    license = licenses.bsd3;
    maintainers = with maintainers; [ twey ];
  };
}
