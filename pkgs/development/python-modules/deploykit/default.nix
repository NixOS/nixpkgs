{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  bash,
  openssh,
  pytestCheckHook,
  pythonOlder,
  stdenv,
}:

buildPythonPackage rec {
  pname = "deploykit";
  version = "1.2.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "numtide";
    repo = "deploykit";
    rev = version;
    hash = "sha256-rHnCMXvDU7knbGivnnMkcOsAuIVbN+g6TDy03B29T5Y=";
  };

  build-system = [ hatchling ];

  nativeCheckInputs = [
    bash
    openssh
    pytestCheckHook
  ];

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [ "test_ssh" ];

  # don't swallow stdout/stderr
  pytestFlags = [ "-s" ];

  pythonImportsCheck = [ "deploykit" ];

  meta = with lib; {
    description = "Execute commands remote via ssh and locally in parallel with python";
    homepage = "https://github.com/numtide/deploykit";
    changelog = "https://github.com/numtide/deploykit/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [
      mic92
      zowoq
    ];
    platforms = platforms.unix;
  };
}
