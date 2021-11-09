{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, bson
, pytest
, pytest-cov
, pytest-runner
, pytestCheckHook
, pyyaml
, setuptools
}:

buildPythonPackage rec {
  pname = "pymarshal";
  version = "2.2.0";
  disabled = pythonOlder "3.0";

  src = fetchFromGitHub {
    owner = "stargateaudio";
    repo = pname;
    rev = version;
    sha256 = "sha256-Ds8JV2mtLRcKXBvPs84Hdj3MxxqpeV5muKCSlAFCj1A=";
  };

  nativeBuildInputs = [
    setuptools
    pytest-runner
  ];

  propagatedBuildInputs = [
    bson
  ];

  checkInputs = [
    pytestCheckHook
    bson
    pytest
    pytest-cov
    pyyaml
  ];

  pytestFlagsArray = [ "test" ];

  meta = {
    description = "Python data serialization library";
    homepage = "https://github.com/stargateaudio/pymarshal";
    maintainers = with lib.maintainers; [ yuu ];
    license = lib.licenses.bsd2;
  };
}
