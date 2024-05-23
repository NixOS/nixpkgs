{
  lib,
  python,
  fetchFromGitHub,
  fetchpatch2,
  buildPythonPackage,
  cython,
  setuptools,
  libstemmer,
}:

buildPythonPackage rec {
  pname = "pystemmer";
  version = "2.2.0.1";
  pyproejct = true;

  src = fetchFromGitHub {
    owner = "snowballstem";
    repo = "pystemmer";
    rev = "refs/tags/v${version}";
    hash = "sha256-ngPx95ybgJmndpNPBwCa3BCNsozRg+dlEw+nhlIwI58=";
  };

  patches = [
    (fetchpatch2 {
      # relax cython constraint
      name = "pystemmer-relax-cython.patch";
      url = "https://github.com/snowballstem/pystemmer/commit/d3d423dc877b4f49e0ab1776f7edaff37feb6799.patch";
      hash = "sha256-9K6gy/cLFPfW82XYHVVPXUbQhf8XyB4NUi4YqNtyWcw=";
    })
  ];

  build-system = [
    cython
    setuptools
  ];

  postConfigure = ''
    export PYSTEMMER_SYSTEM_LIBSTEMMER="${lib.getDev libstemmer}/include"
  '';

  env.NIX_CFLAGS_COMPILE = toString [ "-I${lib.getDev libstemmer}/include" ];

  NIX_CFLAGS_LINK = [ "-L${libstemmer}/lib" ];

  pythonImportsCheck = [ "Stemmer" ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} runtests.py
    runHook postCheck
  '';

  meta = with lib; {
    description = "Snowball stemming algorithms, for information retrieval";
    downloadPage = "https://github.com/snowballstem/pystemmer";
    homepage = "http://snowball.tartarus.org/";
    license = with licenses; [
      bsd3
      mit
    ];
    platforms = platforms.unix;
  };
}
