{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  algaeff,
  bwd,
}:

buildDunePackage rec {
  pname = "asai";
  version = "0.3.1";
  src = fetchFromGitHub {
    owner = "RedPRL";
    repo = pname;
    rev = version;
    hash = "sha256-IpRLX7umpmlNt2uV2MB+YvjAvNk0+gl5plbBExVvcdM=";
  };

  propagatedBuildInputs = [
    algaeff
    bwd
  ];

  meta = with lib; {
    description = "Library for constructing and printing compiler diagnostics";
    homepage = "https://redprl.org/asai/asai/";
    license = licenses.asl20;
    maintainers = [ maintainers.vbgl ];
  };
}
