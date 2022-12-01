{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, python
, cffi
, pytestCheckHook
, ApplicationServices
}:

buildPythonPackage rec {
  pname = "pymunk";
  version = "6.4.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "sha256-YNzZ/wQz5s5J5ctXekNo0FksRoX03rZE1wXIghYcck4=";
  };

  propagatedBuildInputs = [ cffi ];
  buildInputs = lib.optionals stdenv.isDarwin [
    ApplicationServices
  ];

  preBuild = ''
    ${python.interpreter} setup.py build_ext --inplace
  '';

  checkInputs = [ pytestCheckHook ];
  pytestFlagsArray = [
    "pymunk/tests"
  ];
  pythonImportsCheck = [ "pymunk" ];

  meta = with lib; {
    description = "2d physics library";
    homepage = "https://www.pymunk.org";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ emilytrau ];
    platforms = platforms.unix;
  };
}
