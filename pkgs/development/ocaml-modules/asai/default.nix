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

  minimalOCamlVersion = "5.2";

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

  meta = {
    description = "Library for constructing and printing compiler diagnostics";
    homepage = "https://redprl.org/asai/asai/";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
