{ lib, fetchFromGitHub, buildDunePackage
, algaeff
, bwd
, eio
, eio_main
, lsp
, notty
}:

buildDunePackage rec {
  pname = "asai";
  version = "0.1.1";
  src = fetchFromGitHub {
    owner = "RedPRL";
    repo = pname;
    rev = version;
    hash = "sha256-Jd90WhSjK4K2amFA5uyGF57NzsgHA8QiccX6qtxO1rQ=";
  };

  propagatedBuildInputs = [
    algaeff
    bwd
    lsp
    eio
    eio_main
    notty
  ];

  meta = {
    description = "Library for constructing and printing compiler diagnostics";
    homepage = "https://redprl.org/asai/asai/";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
