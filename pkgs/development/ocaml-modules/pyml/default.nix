{
  buildDunePackage,
  lib,
  fetchFromGitHub,
  utop,
  python3,
  stdcompat,
}:

buildDunePackage rec {
  pname = "pyml";
  version = "20231101";

  src = fetchFromGitHub {
    owner = "ocamllibs";
    repo = "pyml";
    tag = version;
    hash = "sha256-WPtmj9EEs7P72OXWJg1syIrbLuh7u4V4W4nyozXmSa0=";
  };

  buildInputs = [
    utop
  ];

  propagatedBuildInputs = [
    python3
    stdcompat
  ];

  nativeCheckInputs = [
    python3.pkgs.numpy
    python3.pkgs.ipython
  ];

  strictDeps = true;

  doCheck = true;

  meta = {
    description = "OCaml bindings for Python";
    homepage = "https://github.com/ocamllibs/pyml";
    license = lib.licenses.bsd2;
  };
}
