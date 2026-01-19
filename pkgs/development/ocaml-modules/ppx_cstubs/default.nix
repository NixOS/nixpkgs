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

  env =
    # Fix build with gcc15
    lib.optionalAttrs
      (
        lib.versionAtLeast ocaml.version "4.10" && lib.versionOlder ocaml.version "4.14"
        || lib.versions.majorMinor ocaml.version == "5.0"
      )
      {
        NIX_CFLAGS_COMPILE = "-std=gnu11";
      };

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

  meta = {
    homepage = "https://github.com/fdopen/ppx_cstubs";
    changelog = "https://github.com/fdopen/ppx_cstubs/raw/${version}/CHANGES.md";
    description = "Preprocessor for easier stub generation with ocaml-ctypes";
    license = lib.licenses.lgpl21Plus;
    maintainers = [ lib.maintainers.osener ];
    broken = lib.versionAtLeast ocaml.version "5.2";
  };
}
