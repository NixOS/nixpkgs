{
  stdenv,
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  six,
  icu,
}:

buildPythonPackage rec {
  pname = "pyicu";
  version = "2.14";
  format = "setuptools";

  src = fetchPypi {
    pname = "PyICU";
    inherit version;
    hash = "sha256-rMfrkr1cVU7VdyScaXhFCk/toKpvAUcBUrOns4KgITI=";
  };

  patches = lib.optionals stdenv.hostPlatform.isDarwin [
    # fails testExemplarSet2 test due to sjd locale not having an auxiliary
    # esType. icuReal doesn't have an sjd locale
    ./skip-sjd-local.diff
  ];

  nativeBuildInputs = [ icu ]; # for icu-config, but should be replaced with pkg-config
  buildInputs = [ icu ];
  nativeCheckInputs = [
    pytestCheckHook
    six
  ];

  pythonImportsCheck = [ "icu" ];

  meta = with lib; {
    homepage = "https://gitlab.pyicu.org/main/pyicu";
    description = "Python extension wrapping the ICU C++ API";
    changelog = "https://gitlab.pyicu.org/main/pyicu/-/raw/v${version}/CHANGES";
    license = licenses.mit;
  };
}
