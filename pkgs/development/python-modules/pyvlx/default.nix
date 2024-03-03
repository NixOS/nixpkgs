{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, pyyaml
, setuptools
, typing-extensions
, zeroconf
}:

buildPythonPackage rec {
  pname = "pyvlx";
  version = "0.2.22";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "Julius2342";
    repo = "pyvlx";
    rev = "refs/tags/${version}";
    hash = "sha256-Ne/mEgvD2ANb5ER0y3eSW4TsPmrqDX1Pvki+0cb+t7w=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    pyyaml
    typing-extensions
    zeroconf
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pyvlx"
  ];

  meta = with lib; {
    description = "Python client to work with Velux units";
    longDescription = ''
      PyVLX uses the Velux KLF 200 interface to control io-Homecontrol
      devices, e.g. Velux Windows.
    '';
    homepage = "https://github.com/Julius2342/pyvlx";
    changelog = "https://github.com/Julius2342/pyvlx/releases/tag/${version}";
    license = with licenses; [ lgpl2Only ];
    maintainers = with maintainers; [ fab ];
    broken = stdenv.isDarwin;
  };
}
