{
  stdenv,
  lib,
  buildPythonPackage,
  fetchFromGitHub,

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
  version = "5.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lxml";
    repo = "lxml";
    rev = "refs/tags/lxml-${version}";
    hash = "sha256-xhKtqsh5FfgXt1fKUhN/Aib/004P7epArv3/XxDSBtw=";
  };

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
