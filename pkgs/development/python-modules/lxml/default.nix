{
  stdenv,
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cython,
  setuptools,
  pkg-config,

  # native dependencies
  libxml2,
  libxslt,
  zlib,
  xcodebuild,
}:

buildPythonPackage (finalAttrs: {
  pname = "lxml";
  version = "6.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lxml";
    repo = "lxml";
    tag = "lxml-${finalAttrs.version}";
    hash = "sha256-SRJaegK4PxgK0rdILVp3J92VnjPmExiD2AuMLoGQIbA=";
  };

  build-system = [
    cython
    setuptools
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ xcodebuild ];

  # required for build time dependency check
  nativeBuildInputs = [
    pkg-config
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

  meta = {
    changelog = "https://github.com/lxml/lxml/blob/${finalAttrs.src.tag}/CHANGES.txt";
    description = "Pythonic binding for the libxml2 and libxslt libraries";
    homepage = "https://lxml.de";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
})
