{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  cmake,
  ninja,
  cffi,
  scikit-build-core,
  bitstring,
  pytestCheckHook,
  pytest-xdist,
  sphinxHook,
  furo,
  myst-parser,
  sphinx-autodoc-typehints,
}:

buildPythonPackage rec {
  pname = "pyvex";
  version = "9.2.204";
  pyproject = true;

  outputs = [
    "out"
    "doc"
    "man"
  ];

  src = fetchFromGitHub {
    owner = "angr";
    repo = pname;
    tag = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-FzvJrAWPqKb0nrk6Y2iAu8TMRx81/BbUlrjf86gvySo=";
  };

  build-system = [
    cmake
    ninja
    scikit-build-core
    cffi
  ];

  dependencies = [
    bitstring
    cffi
  ];

  dontUseCmakeConfigure = true;

  nativeBuildInputs = [
    sphinxHook
    furo
    myst-parser
    sphinx-autodoc-typehints
  ];

  sphinxBuilders = [
    "html"
    "man"
  ];

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace vex/Makefile-gcc \
      --replace-fail '/usr/bin/ar' 'ar'
  '';

  nativeCheckInputs = [
    pytest-xdist
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pyvex" ];

  meta = {
    description = "Python interface to libVEX and VEX IR";
    homepage = "https://github.com/angr/pyvex";
    license = with lib.licenses; [
      bsd2
      gpl2Only
    ];
    maintainers = with lib.maintainers; [
      fab
      misaka18931
    ];
  };
}
