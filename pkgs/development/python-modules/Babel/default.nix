{ stdenv, lib, buildPythonPackage, fetchPypi, pytz, pytestCheckHook, freezegun }:

buildPythonPackage rec {
  pname = "Babel";
  version = "2.9.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bc0c176f9f6a994582230df350aa6e05ba2ebe4b3ac317eab29d9be5d2768da0";
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
