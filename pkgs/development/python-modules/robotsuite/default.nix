{ lib, buildPythonPackage, fetchPypi
, unittest2, lxml, robotframework
}:

buildPythonPackage rec {
  pname = "robotsuite";
  version = "2.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-iugVKUPl6HTTO8K1EbSqAk1fl/fsEPoOcsOnnAgcEas=";
  };

  buildInputs = [ unittest2 ];
  propagatedBuildInputs = [ robotframework lxml ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace robotframework-python3 robotframework
  '';

  meta = with lib; {
    description = "Python unittest test suite for Robot Framework";
    homepage = "https://github.com/collective/robotsuite/";
    license = licenses.gpl3;
  };
}
