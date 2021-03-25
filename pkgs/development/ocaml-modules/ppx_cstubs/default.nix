{ lib
, fetchFromGitHub
, buildDunePackage
, bigarray-compat
, containers
, cppo
, ctypes
, integers
, num
, ppxlib
, re
}:

buildDunePackage rec {
  pname = "ppx_cstubs";
  version = "0.6.1.1";

  useDune2 = true;

  src = fetchFromGitHub {
    owner = "fdopen";
    repo = "ppx_cstubs";
    rev = version;
    sha256 = "0rgg78435ypi6ryhcq5ljkch4qjvra2jqjd47c2hhhcbwvi2ssxh";
  };

  buildInputs = [
    bigarray-compat
    containers
    cppo
    ctypes
    integers
    num
    ppxlib
    re
  ];

  meta = with lib; {
    homepage = "https://github.com/fdopen/ppx_cstubs";
    description = "Preprocessor for easier stub generation with ocaml-ctypes";
    license = licenses.mit;
    maintainers = [ maintainers.osener ];
  };
}
