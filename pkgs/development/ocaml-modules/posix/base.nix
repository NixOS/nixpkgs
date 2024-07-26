{ lib, buildDunePackage, fetchFromGitHub
, ctypes, integers
}:

buildDunePackage rec {
  pname = "posix-base";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-posix";
    rev = "v${version}";
    hash = "sha256-xxNaPJZdcW+KnT7rYUuC7ZgmHtXTppZG2BOmpKweC/U=";
  };

  duneVersion = "3";
  minimalOCamlVersion = "4.08";

  propagatedBuildInputs = [ ctypes integers ];

  meta = {
    homepage = "https://www.liquidsoap.info/ocaml-posix/";
    description = "Base module for the posix bindings";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
