{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, python
, cffi
, pytestCheckHook
, pythonOlder
, ApplicationServices
}:

buildPythonPackage rec {
  pname = "pymunk";
  version = "6.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    hash = "sha256-YNzZ/wQz5s5J5ctXekNo0FksRoX03rZE1wXIghYcck4=";
  };

  propagatedBuildInputs = [
    cffi
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    ApplicationServices
  ];

  preBuild = ''
    ${python.pythonForBuild.interpreter} setup.py build_ext --inplace
  '';

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "pymunk/tests"
  ];

  pythonImportsCheck = [
    "pymunk"
  ];

  meta = with lib; {
    description = "2d physics library";
    homepage = "https://www.pymunk.org";
    changelog = "https://github.com/viblo/pymunk/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ emilytrau ];
    platforms = platforms.unix;
  };
}
