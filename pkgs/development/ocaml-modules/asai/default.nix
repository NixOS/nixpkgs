{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  algaeff,
  bwd,
}:

buildDunePackage rec {
  pname = "asai";
  version = "0.3.0";
  src = fetchFromGitHub {
    owner = "RedPRL";
    repo = pname;
    rev = version;
    hash = "sha256-Rp4TvSbRz+5+X4XJ1tKUDDgldpLzHHtaF7G7AG6HgKU=";
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
