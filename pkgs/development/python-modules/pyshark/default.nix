{
  lib,
  stdenv,
  appdirs,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  lxml,
  packaging,
  pytestCheckHook,
  replaceVars,
  setuptools,
  termcolor,
  wireshark-cli,
}:

buildPythonPackage rec {
  pname = "pyshark";
  version = "0.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "KimiNewt";
    repo = "pyshark";
    tag = "v${version}";
    hash = "sha256-kzJDzUK6zknUyXPdKc4zMvWim4C5NQCSJSS45HI6hKM=";
  };

  # `stripLen` does not seem to work here
  patchFlags = [ "-p2" ];

  patches = [
    # fixes capture test
    (fetchpatch {
      url = "https://github.com/KimiNewt/pyshark/commit/7142c5bf88abcd4c65c81052a00226d6155dda42.patch";
      hash = "sha256-Ti7cwRyYSbF4a4pEEV9FntNevkV/JVXNqACQWzoma7g=";
    })
    # fixes tests that failed related to elastic-mapping
    # remove fix if this is ever merged upstream
    (fetchpatch {
      url = "https://github.com/KimiNewt/pyshark/commit/0e1d8d0e06108f2887c3147c93049de63b475f8a.patch";
      hash = "sha256-fpgiBHcfS/TGYIB65ioZJrWUuDIrLxxXqGVJ9y18b2w=";
    })
    (replaceVars ./hardcode-tshark-path.patch {
      tshark = lib.getExe' wireshark-cli "tshark";
    })
  ];

  sourceRoot = "${src.name}/src";

  build-system = [ setuptools ];

  dependencies = [
    appdirs
    lxml
    packaging
    termcolor
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  disabledTests = [
    # flaky
    # KeyError: 'Packet of index 0 does not exist in capture'
    "test_getting_packet_summary"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # fails on darwin
    # _pickle.PicklingError: logger cannot be pickled
    "test_iterate_empty_psml_capture"
  ];

  pythonImportsCheck = [ "pyshark" ];

  enabledTestPaths = [ "../tests/" ];

  meta = with lib; {
    description = "Python wrapper for tshark, allowing Python packet parsing using Wireshark dissectors";
    homepage = "https://github.com/KimiNewt/pyshark/";
    changelog = "https://github.com/KimiNewt/pyshark/releases/tag/${version}";
    license = licenses.mit;
    maintainers = [ ];
  };
}
