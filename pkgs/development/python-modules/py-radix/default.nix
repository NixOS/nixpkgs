{ lib
, buildPythonPackage
, pythonAtLeast
, fetchFromGitHub
, coverage
, nose
}:

buildPythonPackage rec {
  pname = "py-radix";
  version = "0.10.0";

  disabled = pythonAtLeast "3.10"; # abandoned, remove when we move to py310/py311

  src = fetchFromGitHub {
    owner = "mjschultz";
    repo = "py-radix";
    rev = "v${version}";
    sha256 = "01xyn9lg6laavnzczf5bck1l1c2718ihxx0hvdkclnnxjqhbrqis";
  };

  doCheck = true;
  nativeCheckInputs = [ coverage nose ];

  meta = with lib; {
    description = "Python radix tree for IPv4 and IPv6 prefix matching";
    homepage = "https://github.com/mjschultz/py-radix";
    license = with licenses; [ isc bsdOriginal ];
    maintainers = with maintainers; [ mkg ];
  };
}
