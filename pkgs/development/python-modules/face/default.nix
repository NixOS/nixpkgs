{ lib, buildPythonPackage, fetchPypi, boltons, pytest }:

buildPythonPackage rec {
  pname = "face";
  version = "20.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7d59ca5ba341316e58cf72c6aff85cca2541cf5056c4af45cb63af9a814bed3e";
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
