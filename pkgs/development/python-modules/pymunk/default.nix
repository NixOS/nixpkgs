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
  version = "6.1.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "1k1ncrssywvfrbmai7d20h2mg4lzhq16rhw3dkg4ad5nhik3k0sl";
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
    maintainers = with maintainers; [ angustrau ];
    platforms = platforms.linux ++ [ "x86_64-darwin" ];
  };
}
