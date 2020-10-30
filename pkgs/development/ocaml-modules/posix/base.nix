{ lib, buildDunePackage, fetchFromGitHub
, ctypes, integers
}:

buildDunePackage rec {
  pname = "posix-base";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-posix";
    rev = "v${version}";
    sha256 = "18px8hfqcfy2lk8105ki3hrxxigs44gs046ba0fqda6wzd0hr82b";
  };

  useDune2 = true;

  propagatedBuildInputs = [ ctypes integers ];

  meta = {
    homepage = "https://www.liquidsoap.info/ocaml-posix/";
    description = "Base module for the posix bindings";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
