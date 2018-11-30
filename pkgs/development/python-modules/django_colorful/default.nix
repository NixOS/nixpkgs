{ stdenv
, buildPythonPackage
, fetchPypi
, django
}:

buildPythonPackage rec {
  pname = "django-colorful";
  version = "1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0y34hzvfrm1xbxrd8frybc9yzgqvz4c07frafipjikw7kfjsw8az";
  };

  # Tests aren't run
  doCheck = false;

  # Requires Django >= 1.8
  buildInputs = [ django ];

  meta = with stdenv.lib; {
    description = "Django extension that provides database and form color fields";
    homepage = https://github.com/charettes/django-colorful;
    license = licenses.mit;
  };

}
