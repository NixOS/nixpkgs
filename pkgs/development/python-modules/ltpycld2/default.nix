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

  meta = with lib; {
    description = "Python bindings around Google Chromium's embedded compact language detection library (CLD2)";
    homepage = "https://github.com/LibreTranslate/pycld2";
    license = licenses.asl20;
    maintainers = with maintainers; [ misuzu ];
    broken = stdenv.isDarwin;
  };
}
