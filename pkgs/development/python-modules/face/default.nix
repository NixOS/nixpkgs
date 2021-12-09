{ lib, buildPythonPackage, fetchFromGitHub, boltons, pytest }:

buildPythonPackage rec {
  pname = "face";
  version = "20.1.1";

  src = fetchFromGitHub {
     owner = "mahmoud";
     repo = "face";
     rev = "v20.1.1";
     sha256 = "09slk25vp2dbmaacgk06ga4pay4x2valc469xr7mzzvxpailjlr1";
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
