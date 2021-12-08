{ lib
, buildPythonPackage
, fetchFromGitHub
, six
, nose
, coverage
}:

buildPythonPackage rec {
  pname = "aadict";
  version = "0.2.3";

  src = fetchFromGitHub {
     owner = "metagriffin";
     repo = "aadict";
     rev = "v0.2.3";
     sha256 = "0419s6jdz99ibd949bj5i2sdlqcjah7crh9c5xywjwl1li8dwgin";
  };

  propagatedBuildInputs = [ six ];
  checkInputs = [ nose coverage ];

  meta = with lib; {
    homepage = "https://github.com/metagriffin/aadict";
    description = "An auto-attribute dict (and a couple of other useful dict functions).";
    maintainers = with maintainers; [ glittershark ];
    license = licenses.gpl3;
  };
}
