{ lib, fetchurl, buildDunePackage
, repr, ppx_repr, fmt, logs, mtime, stdlib-shims
, cmdliner, progress, semaphore-compat
, alcotest, crowbar, re
}:

buildDunePackage rec {
  pname = "index";
  version = "1.3.1";

  src = fetchurl {
    url = "https://github.com/mirage/index/releases/download/${version}/index-${version}.tbz";
    sha256 = "sha256-ycZi/TFLoGRloSpjYqH5FCHWP3eyiTCIDLESEn5inuI=";
  };

  minimumOCamlVersion = "4.08";
  useDune2 = true;

  buildInputs = [
    stdlib-shims
  ];
  propagatedBuildInputs = [
    cmdliner
    fmt
    logs
    mtime
    ppx_repr
    progress
    repr
    semaphore-compat
  ];

  checkInputs = [
    alcotest
    crowbar
    re
  ];
  doCheck = true;

  meta = with lib; {
    description = "A platform-agnostic multi-level index";
    homepage = "https://github.com/mirage/index";
    license = licenses.mit;
    maintainers = with maintainers; [ vbgl ];
  };
}
