{
  lib,
  stdenv,
  buildPythonPackage,
  pythonOlder,
  rustPlatform,
  libiconv,
  fetchFromGitHub,
}:
let
  pname = "nh3";
<<<<<<< HEAD
  version = "0.3.2";
=======
  version = "0.2.21";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  src = fetchFromGitHub {
    owner = "messense";
    repo = "nh3";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-2D8ZLmVRA+SuMqeUsSXyY+0zlgqp7TSRyQuJMjmRVFk=";
=======
    hash = "sha256-DskjcKjdz1HmKzmA568zRCjh4UK1/LBD5cSIu7Rfwok=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
in
buildPythonPackage {
  inherit pname version src;
  format = "pyproject";
  disabled = pythonOlder "3.8";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
<<<<<<< HEAD
    hash = "sha256-dN6zdwMGh8stgDuGiO+T/ZZ3/3P9Wu/gUw5gHJ1pPGA=";
=======
    hash = "sha256-1Ytca/GiHidR8JOcz+DydN6N/iguLchbP8Wnrd/0NTk=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  pythonImportsCheck = [ "nh3" ];

<<<<<<< HEAD
  meta = {
    description = "Python binding to Ammonia HTML sanitizer Rust crate";
    homepage = "https://github.com/messense/nh3";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ happysalada ];
=======
  meta = with lib; {
    description = "Python binding to Ammonia HTML sanitizer Rust crate";
    homepage = "https://github.com/messense/nh3";
    license = licenses.mit;
    maintainers = with maintainers; [ happysalada ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
