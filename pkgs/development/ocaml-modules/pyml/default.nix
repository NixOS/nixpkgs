{ buildDunePackage
, lib
, fetchFromGitHub
, fetchpatch
, utop
, python3
, stdcompat
}:

buildDunePackage rec {
  pname = "pyml";
  version = "20220905";

  src = fetchFromGitHub {
    owner = "thierry-martinez";
    repo = "pyml";
    rev = version;
    sha256 = "PL4tFIKQLRutSn9Sf84/ImJv0DqkstNnJaNBqWDTKDQ=";
  };

  patches = [
    # Fixes test crash.
    # https://github.com/thierry-martinez/pyml/issues/85
    (fetchpatch {
      url = "https://github.com/thierry-martinez/pyml/commit/a0bc5aca8632bea273f869d622cad2f55e754a7c.patch";
      sha256 = "bOqAokm5DE5rlvkBMQZtwMppRmoK9cvjJeGeP6BusnE=";
      excludes = [
        "CHANGES.md"
      ];
    })
    (fetchpatch {
      url = "https://github.com/thierry-martinez/pyml/commit/97407473800b3f6215190643c1e6b9bd25d5caeb.patch";
      hash = "sha256-7CrVuV4JT7fyi/ktWz4nNOG/BbqsQVCoJwCAhE2y4YU=";
    })
  ];

  buildInputs = [
    utop
  ];

  propagatedBuildInputs = [
    python3
    stdcompat
  ];

  nativeCheckInputs = [
    python3.pkgs.numpy python3.pkgs.ipython
  ];

  strictDeps = true;

  doCheck = true;

  meta = {
    description = "OCaml bindings for Python";
    homepage = "https://github.com/thierry-martinez/pyml";
    license = lib.licenses.bsd2;
  };
}
