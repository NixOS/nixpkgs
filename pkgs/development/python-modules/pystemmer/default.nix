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

buildPythonPackage (finalAttrs: {
  pname = "pystemmer";
  version = "3.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "snowballstem";
    repo = "pystemmer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GPPl6ioB9sB2y8G2hYfu2ksR+D9xNJjK6glMADLnr7M=";
  };

  patches = [
    # These 2 patches should be removed on the next version bump after 3.1.0
    (fetchpatch2 {
      name = "libstemmer-3.1-algorithms.patch";
      url = "https://github.com/snowballstem/pystemmer/commit/301c074791708ab2c479808b410480c34183cd9a.patch?full_index=1";
      hash = "sha256-830nep2gjlVuVaepsHIkzL/U4fejwK0jH+WujLrOfUs=";
    })
    (fetchpatch2 {
      name = "dont-hard-code-algorithms-doctest.patch";
      url = "https://github.com/snowballstem/pystemmer/commit/77ee7b34fdcd61c78146ae4c6e536a63755db0e6.patch?full_index=1";
      hash = "sha256-eEfNFpD6T+prokVnpAOx4rABCPS5YXdbG3xKdJzb48M=";
    })
  ];

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
    homepage = "https://github.com/snowballstem/pystemmer";
    license = with lib.licenses; [
      bsd3
      mit
    ];
    platforms = lib.platforms.unix;
  };
})
