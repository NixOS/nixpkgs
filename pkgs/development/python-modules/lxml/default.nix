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
  version = "5.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lxml";
    repo = "lxml";
    tag = "lxml-${version}";
    hash = "sha256-yp0Sb/0Em3HX1XpDNFpmkvW/aXwffB4D1sDYEakwKeY=";
  };

  build-system = [
    cython
    setuptools
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ xcodebuild ];

  # required for build time dependency check
  nativeBuildInputs = [
    libxml2.dev
    libxslt.dev
  ];

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
