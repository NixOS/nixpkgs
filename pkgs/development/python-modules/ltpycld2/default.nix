{
  stdenv,
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "ltpycld2";
  version = "0.42";

  format = "setuptools";

  src = fetchPypi {
    pname = "LTpycld2";
    inherit version;
    hash = "sha256-lI0MGrVRirTvy8w81zuyn4CfHfsw9NL72BsXWh/+tRY=";
  };

  doCheck = false; # completely broken tests

  pythonImportsCheck = [ "pycld2" ];

  # Fix build with gcc14
  # https://github.com/aboSamoor/pycld2/pull/62
  env.NIX_CFLAGS_COMPILE = "-Wno-narrowing";

  meta = {
    description = "Python bindings around Google Chromium's embedded compact language detection library (CLD2)";
    homepage = "https://github.com/LibreTranslate/pycld2";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ misuzu ];
  };
}
