{
  lib,
  stdenv,
  appdirs,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  lxml,
  packaging,
  py,
  pytestCheckHook,
  pythonOlder,
  termcolor,
  wireshark-cli,
}:

buildPythonPackage rec {
  pname = "pyshark";
  version = "0.6";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "KimiNewt";
    repo = pname;
    rev = "refs/tags/v${version}";
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
  ];

  sourceRoot = "${src.name}/src";

  # propagate wireshark, so pyshark can find it when used
  propagatedBuildInputs = [
    appdirs
    lxml
    packaging
    py
    termcolor
    wireshark-cli
  ];

  nativeCheckInputs = [
    py
    pytestCheckHook
    wireshark-cli
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  disabledTests =
    [
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

  pytestFlagsArray = [ "../tests/" ];

  meta = with lib; {
    description = "Python wrapper for tshark, allowing Python packet parsing using Wireshark dissectors";
    homepage = "https://github.com/KimiNewt/pyshark/";
    changelog = "https://github.com/KimiNewt/pyshark/releases/tag/${version}";
    license = licenses.mit;
    maintainers = [ ];
  };
}
