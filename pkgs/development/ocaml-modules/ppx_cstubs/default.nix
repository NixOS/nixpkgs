{
  lib,
  ocaml,
  fetchFromGitHub,
  buildDunePackage,
  bigarray-compat,
  containers,
  cppo,
  ctypes,
  integers,
  num,
  ppxlib,
  re,
  findlib,
}:

buildDunePackage rec {
  pname = "ppx_cstubs";
  version = "0.7.0";

  minimalOCamlVersion = "4.08";

  src = fetchFromGitHub {
    owner = "fdopen";
    repo = "ppx_cstubs";
    rev = version;
    hash = "sha256-qMmwRWCIfNyhCQYPKLiufnb57sTR3P+WInOqtPDywFs=";
  };

  patches = [ ./ppxlib.patch ];

  nativeBuildInputs = [ cppo ];

  buildInputs = [
    bigarray-compat
    containers
    findlib
    integers
    num
    ppxlib
    re
  ];

  propagatedBuildInputs = [
    ctypes
  ];

  meta = with lib; {
    homepage = "https://github.com/fdopen/ppx_cstubs";
    changelog = "https://github.com/fdopen/ppx_cstubs/raw/${version}/CHANGES.md";
    description = "Preprocessor for easier stub generation with ocaml-ctypes";
    license = licenses.lgpl21Plus;
    maintainers = [ maintainers.osener ];
    broken = lib.versionAtLeast ocaml.version "5.2";
  };
}
