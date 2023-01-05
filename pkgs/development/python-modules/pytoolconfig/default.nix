{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, pythonOlder

# build
, pdm-pep517

# docs
, docutils
, sphinxHook
, sphinx-rtd-theme
, sphinx-autodoc-typehints

# runtime
, tomli
, packaging

# optionals
, pydantic
, platformdirs
, sphinx
, tabulate

# tests
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pytoolconfig";
  version = "1.2.4";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "bagel897";
    repo = "pytoolconfig";
    rev = "refs/tags/v${version}";
    hash = "sha256-UdBPp9Ur3+hYn2CBY91jK1hT/GHyA8qbQ3w0OuLBrFU=";
  };

  outputs = [
    "out"
    "doc"
  ];

  PDM_PEP517_SCM_VERSION = version;

  nativeBuildInputs = [
    pdm-pep517

    # docs
    docutils
    sphinx-autodoc-typehints
    sphinx-rtd-theme
    sphinxHook
  ] ++ passthru.optional-dependencies.doc;

  patches = [
    (fetchpatch {
      # Fix documentation build
      url = "https://github.com/bagel897/pytoolconfig/commit/c8a010842d738242d6bb8deb28ecd62342a60e03.patch";
      hash = "sha256-hYcPjQeHYGtSPy363RVS5YgQ+obJQuC+Q9ZuOGvKRAY=";
    })
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "packaging>=22.0" "packaging"
  '';

  propagatedBuildInputs = [
    packaging
  ] ++ lib.optionals (pythonOlder "3.11") [
    tomli
  ];

  passthru.optional-dependencies = {
    validation = [ pydantic ];
    global = [ platformdirs ];
    doc = [ sphinx tabulate ];
  };

  pythonImportsCheck = [
    "pytoolconfig"
  ];

  checkInputs = [
    pytestCheckHook
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  meta = with lib; {
    changelog = "https://github.com/bagel897/pytoolconfig/releases/tag/v${version}";
    description = "Python tool configuration";
    homepage = "https://github.com/bagel897/pytoolconfig";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ hexa ];
  };
}
