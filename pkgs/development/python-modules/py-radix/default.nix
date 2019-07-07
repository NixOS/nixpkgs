{ stdenv
, buildPythonPackage
, fetchFromGitHub
, coverage
, nose
}:

buildPythonPackage rec {
  pname = "py-radix";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "mjschultz";
    repo = "py-radix";
    rev = "v${version}";
    sha256 = "01xyn9lg6laavnzczf5bck1l1c2718ihxx0hvdkclnnxjqhbrqis";
  };

  doCheck = true;
  checkInputs = [ coverage nose ];

  meta = with stdenv.lib; {
    description = "Python radix tree for IPv4 and IPv6 prefix matching";
    homepage = https://github.com/mjschultz/py-radix;
    license = with licenses; [ isc bsdOriginal ];
    maintainers = with maintainers; [ mkg ];
  };
}
