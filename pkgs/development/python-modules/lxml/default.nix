{
  stdenv,
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,

  # build-system
  cython,
  setuptools,

  # native dependencies
  libxml2,
  libxslt,
  zlib,
  xcodebuild,
}:

buildPythonPackage rec {
  pname = "lxml";
  version = "5.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lxml";
    repo = "lxml";
    tag = "lxml-${version}";
    hash = "sha256-TGv2ZZQ7GU+fAWRApESUL1bbxQobbmLai8wr09xYOUw=";
  };

  patches = lib.optionals (lib.versionOlder version "5.5") [
    # Fix for Cython 3.1.0 that should be included in lxml version 5.5
    (fetchpatch {
      url = "https://github.com/lxml/lxml/commit/6d5d6aed2e38e1abc625f29c0b3e97fc8c60ae3b.patch";
      hash = "sha256-HQTJZTfMqRc8mwyeNoRFFbYy8f1GBScMPqUiyQB3lHE=";
    })
  ];

  # setuptoolsBuildPhase needs dependencies to be passed through nativeBuildInputs
  nativeBuildInputs = [
    libxml2.dev
    libxslt.dev
    cython
    setuptools
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ xcodebuild ];
  buildInputs = [
    libxml2
    libxslt
    zlib
  ];

  env = lib.optionalAttrs stdenv.cc.isClang {
    NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-function-pointer-types";
  };

  # tests are meant to be ran "in-place" in the same directory as src
  doCheck = false;

  pythonImportsCheck = [
    "lxml"
    "lxml.etree"
  ];

  meta = with lib; {
    changelog = "https://github.com/lxml/lxml/blob/lxml-${version}/CHANGES.txt";
    description = "Pythonic binding for the libxml2 and libxslt libraries";
    homepage = "https://lxml.de";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
