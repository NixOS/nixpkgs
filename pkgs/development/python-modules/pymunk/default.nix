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
  version = "6.2.1";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "18ae0f83ec2dc20892b98c84127ce9149ab40fa3c3120097377e1506884b27b8";
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
