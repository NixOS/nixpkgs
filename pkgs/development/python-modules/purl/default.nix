{ lib, buildPythonPackage, fetchFromGitHub
, nose
, six
}:

buildPythonPackage rec {
  pname = "purl";
  version = "1.5";

  src = fetchFromGitHub {
    owner = "codeinthehole";
    repo = "purl";
    rev = version;
    sha256 = "0vi7xdm2xc1rbqrz5jwpr7x7dnkcrbjf1mb4w1q2c2f8jca0kk0g";
  };

  propagatedBuildInputs = [ six ];

  checkInputs = [ nose ];

  meta = with lib; {
    description = "Immutable URL class for easy URL-building and manipulation";
    homepage = "https://github.com/codeinthehole/purl";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
