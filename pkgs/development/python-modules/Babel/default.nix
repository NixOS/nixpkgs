{ stdenv, lib, buildPythonPackage, fetchPypi, pytz, pytestCheckHook, freezegun }:

buildPythonPackage rec {
  pname = "Babel";
  version = "2.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "018yg7g2pa6vjixx1nx41cfispgfi0azzp0a1chlycbj8jsil0ys";
  };

  propagatedBuildInputs = [ pytz ];

  checkInputs = [ pytestCheckHook freezegun ];

  doCheck = !stdenv.isDarwin;

  meta = with lib; {
    homepage = "http://babel.edgewall.org";
    description = "A collection of tools for internationalizing Python applications";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
