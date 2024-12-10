{
  buildDunePackage,
  lib,
  fetchFromGitHub,
  fetchpatch,
  utop,
  python3,
  stdcompat,
}:

buildDunePackage rec {
  pname = "pyml";
  version = "20231101";

  src = fetchFromGitHub {
    owner = "thierry-martinez";
    repo = "pyml";
    rev = version;
    sha256 = "sha256-0Yy5T/S3Npwt0XJmEsdXGg5AXYi9vV9UG9nMSzz/CEc=";
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
    homepage = "https://github.com/thierry-martinez/pyml";
    license = lib.licenses.bsd2;
  };
}
