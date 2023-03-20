{ lib
, python
, fetchPypi
, fetchFromGitHub
, fetchpatch
, buildPythonPackage
, cython
, libstemmer
 }:

buildPythonPackage rec {
  pname = "pystemmer";
  version = "2.2.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "snowballstem";
    repo = "pystemmer";
    rev = "refs/tags/v${version}";
    hash = "sha256-bJVFeO7XP+aZ2nowQiuws5ziL/FmS1eaOllW6QxA70U=";
  };

  nativeBuildInputs = [ cython ];

  patches = [
    (fetchpatch {
      # Allow building with system libstemmer
      url = "https://github.com/snowballstem/pystemmer/commit/2f52b4b2ff113fe6c33cebe14ed4fd4388bb1742.patch";
      hash = "sha256-JqR/DUmABgWaq23CNjoKSasL0mNhM2QuU986mouK6A8=";
    })
    (fetchpatch {
      # Fix doctests
      url = "https://github.com/snowballstem/pystemmer/commit/b2826f19fe8ba65238b5f3b4cee7096a698f048e.patch";
      hash = "sha256-VTZydjYaJJ/KoHD4KbON36kZnkuAyO51H0Oeg6VXTqg=";
    })
  ];

  postConfigure = ''
    export PYSTEMMER_SYSTEM_LIBSTEMMER="${lib.getDev libstemmer}/include"
  '';

  env.NIX_CFLAGS_COMPILE = toString [
    "-I${lib.getDev libstemmer}/include"
  ];

  NIX_CFLAGS_LINK = [
    "-L${libstemmer}/lib"
  ];

  pythonImportsCheck = [
    "Stemmer"
  ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} runtests.py
    runHook postCheck
  '';

  meta = with lib; {
    description = "Snowball stemming algorithms, for information retrieval";
    homepage = "http://snowball.tartarus.org/";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
