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
  version = "0.6.1.2";

  minimalOCamlVersion = "4.08";

  useDune2 = true;

  src = fetchFromGitHub {
    owner = "fdopen";
    repo = "ppx_cstubs";
    rev = version;
    sha256 = "15cjb9ygnvp2kv85rrb7ncz7yalifyl7wd2hp2cl8r1qrpgi1d0w";
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
    changelog = "https://github.com/fdopen/ppx_cstubs/raw/${version}/CHANGES.md";
    description = "Preprocessor for easier stub generation with ocaml-ctypes";
    license = licenses.lgpl21Plus;
    maintainers = [ maintainers.osener ];
  };
}
