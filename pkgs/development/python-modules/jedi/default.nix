{
  lib,
  stdenv,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  fetchpatch2,

  # build-system
  setuptools,

  # dependencies
  parso,

  # tests
  attrs,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "jedi";
  version = "0.19.1";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "davidhalter";
    repo = "jedi";
    rev = "v${version}";
    hash = "sha256-MD7lIKwAwULZp7yLE6jiao2PU6h6RIl0SQ/6b4Lq+9I=";
    fetchSubmodules = true;
  };

  patches = [
    (fetchpatch2 {
      # pytest8 compat
      url = "https://github.com/davidhalter/jedi/commit/39c8317922f8f0312c12127cad10aea38d0ed7b5.patch";
      hash = "sha256-wXHWcfoRJUl+ADrNMML0+DYTcRTyLs55Qrs7sDqT8BA=";
    })
  ];

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ parso ];

  nativeCheckInputs = [
    attrs
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  disabledTests =
    [
      # sensitive to platform, causes false negatives on darwin
      "test_import"
    ]
    ++ lib.optionals (stdenv.isAarch64 && pythonOlder "3.9") [
      # AssertionError: assert 'foo' in ['setup']
      "test_init_extension_module"
    ]
    ++ lib.optionals (stdenv.targetPlatform.useLLVM or false) [
      # InvalidPythonEnvironment: The python binary is potentially unsafe.
      "test_create_environment_executable"
      # AssertionError: assert ['', '.1000000000000001'] == ['', '.1']
      "test_dict_keys_completions"
      # AssertionError: assert ['', '.1000000000000001'] == ['', '.1']
      "test_dict_completion"
    ];

  meta = with lib; {
    description = "Autocompletion tool for Python that can be used for text editors";
    homepage = "https://github.com/davidhalter/jedi";
    changelog = "https://github.com/davidhalter/jedi/blob/${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = [ ];
  };
}
