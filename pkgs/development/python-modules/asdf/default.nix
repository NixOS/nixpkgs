{ lib
, asdf-standard
, asdf-transform-schemas
, astropy
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, importlib-resources
, jmespath
, jsonschema
, lz4
, numpy
, packaging
, pytest-astropy
, pytestCheckHook
, pythonOlder
, pyyaml
, semantic-version
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "asdf";
  version = "2.13.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "asdf-format/";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-u8e7ot5NDRqQFH0eLVnGinBQmQD73BlR5K9HVjA7SIg=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  patches = [
    # Fix default validation, https://github.com/asdf-format/asdf/pull/1203
    (fetchpatch {
      name = "default-validation.patch";
      url = "https://github.com/asdf-format/asdf/commit/6f79f620b4632e20178d9bd53528702605d3e976.patch";
      hash = "sha256-h/dYhXRCf5oIIC+u6+8C91mJnmEzuNmlEzqc0UEhLy0=";
      excludes = [
          "CHANGES.rst"
      ];
    })
  ];

  postPatch = ''
    # https://github.com/asdf-format/asdf/pull/1203
    substituteInPlace pyproject.toml \
      --replace "'jsonschema >=4.0.1, <4.10.0'," "'jsonschema >=4.0.1',"
  '';

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    asdf-standard
    asdf-transform-schemas
    jmespath
    jsonschema
    numpy
    packaging
    pyyaml
    semantic-version
  ] ++ lib.optionals (pythonOlder "3.9") [
    importlib-resources
  ];

  nativeCheckInputs = [
    astropy
    lz4
    pytest-astropy
    pytestCheckHook
  ];

  preCheck = ''
    export PY_IGNORE_IMPORTMISMATCH=1
  '';

  pythonImportsCheck = [
    "asdf"
  ];

  disabledTests = [
    "config.rst"
  ];

  meta = with lib; {
    description = "Python tools to handle ASDF files";
    homepage = "https://github.com/asdf-format/asdf";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
    # Many tests fail, according to Hydra
    broken = true;
  };
}
