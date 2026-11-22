{
  stdenv,
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  six,
}:

buildPythonPackage rec {
  pname = "jsonstreams";
  version = "0.6.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "dcbaker";
    repo = "jsonstreams";
    rev = version;
    hash = "sha256-WzEu9CbvwAy/7StYfwrRby/t4qKx7oR25Ok/mz4nh2M=";
  };

  propagatedBuildInputs = [ six ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlags = [ "--doctest-modules" ];

  enabledTestPaths = [
    "tests"
    "jsonstreams"
  ];

  meta = {
    broken = stdenv.hostPlatform.isDarwin;
    description = "JSON streaming writer";
    homepage = "https://github.com/dcbaker/jsonstreams";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ chkno ];
  };
}
