{ lib
, argparse-addons
, bitstruct
, buildPythonPackage
, can
, crccheck
, diskcache
, fetchPypi
, matplotlib
, parameterized
, pytestCheckHook
, pythonOlder
, setuptools
, setuptools-scm
, textparser
}:

buildPythonPackage rec {
  pname = "cantools";
  version = "39.4.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-44zzlyOIQ2qo4Zq5hb+xnCy0ANm6iCpcBww0l2KWdMs=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "setuptools_scm>=8" "setuptools_scm"
  '';

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    argparse-addons
    bitstruct
    can
    crccheck
    diskcache
    matplotlib
    textparser
  ];

  nativeCheckInputs = [
    parameterized
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "cantools"
  ];

  meta = with lib; {
    description = "Tools to work with CAN bus";
    homepage = "https://github.com/cantools/cantools";
    changelog = "https://github.com/cantools/cantools/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ gray-heron ];
  };
}
