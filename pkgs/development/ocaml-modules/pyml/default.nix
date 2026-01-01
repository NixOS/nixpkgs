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
<<<<<<< HEAD
    owner = "ocamllibs";
    repo = "pyml";
    tag = version;
    hash = "sha256-0Yy5T/S3Npwt0XJmEsdXGg5AXYi9vV9UG9nMSzz/CEc=";
=======
    owner = "thierry-martinez";
    repo = "pyml";
    rev = version;
    sha256 = "sha256-0Yy5T/S3Npwt0XJmEsdXGg5AXYi9vV9UG9nMSzz/CEc=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
    homepage = "https://github.com/ocamllibs/pyml";
=======
    homepage = "https://github.com/thierry-martinez/pyml";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    license = lib.licenses.bsd2;
  };
}
