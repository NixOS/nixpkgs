{
  lib,
  python,
  fetchFromGitHub,
  buildPythonPackage,
  cython,
  setuptools,
  libstemmer,
}:

buildPythonPackage rec {
  pname = "pystemmer";
  version = "3.0.0";
  format = "setuptools";
  pyproejct = true;

  src = fetchFromGitHub {
    owner = "snowballstem";
    repo = "pystemmer";
    tag = "v${version}";
    hash = "sha256-c3ucbneUo5UBfdrd5Ktl4HriVusvWBEA1brrgahEQ9A=";
  };

  build-system = [
    cython
    setuptools
  ];

  postConfigure = ''
    export PYSTEMMER_SYSTEM_LIBSTEMMER="${lib.getDev libstemmer}/include"
  '';

  env = {
    NIX_CFLAGS_COMPILE = toString [ "-I${lib.getDev libstemmer}/include" ];
    NIX_CFLAGS_LINK = toString [ "-L${libstemmer}/lib" ];
  };

  pythonImportsCheck = [ "Stemmer" ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} runtests.py
    runHook postCheck
  '';

  __structuredAttrs = true;

  meta = {
    description = "Snowball stemming algorithms, for information retrieval";
    downloadPage = "https://github.com/snowballstem/pystemmer";
    homepage = "http://snowball.tartarus.org/";
    license = with lib.licenses; [
      bsd3
      mit
    ];
    platforms = lib.platforms.unix;
  };
}
