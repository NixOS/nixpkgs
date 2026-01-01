{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  rustPlatform,
  cargo,
  rustc,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "gb-io";
<<<<<<< HEAD
  version = "0.3.8";
=======
  version = "0.3.6";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "althonos";
    repo = "gb-io.py";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-ArJTK6YcuyExIMBUYBxpr7TpKeVMF6Nk4ObAZLuOgJA=";
=======
    hash = "sha256-iLRXyiVji9q4C5YtBsTT9bklSueY9RlX7Kz4cu+hmpE=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit
      pname
      version
      src
      sourceRoot
      ;
<<<<<<< HEAD
    hash = "sha256-3mgvT8b4tpoUScs5yk6IbGBUJ/czu3XSdFXhfT/c5S8=";
=======
    hash = "sha256-miwCgZpaFVMaNJLUTYSGEkmg+uT7lbzJZnBa9yZqC8U=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  sourceRoot = src.name;

  nativeBuildInputs = [
    cargo
    rustc
    rustPlatform.cargoSetupHook
  ];

  build-system = [ rustPlatform.maturinBuildHook ];

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "gb_io" ];

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/althonos/gb-io.py";
    description = "Python interface to gb-io, a fast GenBank parser written in Rust";
    license = lib.licenses.mit;
=======
  meta = with lib; {
    homepage = "https://github.com/althonos/gb-io.py";
    description = "Python interface to gb-io, a fast GenBank parser written in Rust";
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = with lib.maintainers; [ dlesl ];
  };
}
