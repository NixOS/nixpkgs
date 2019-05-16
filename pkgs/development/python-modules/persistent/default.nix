{ buildPythonPackage
, fetchPypi
, zope_interface
, sphinx, manuel
}:

buildPythonPackage rec {
  pname = "persistent";
  version = "4.4.3";

  nativeBuildInputs = [ sphinx manuel ];
  propagatedBuildInputs = [ zope_interface ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "05hi8yfvxl5ns7y7xhbgbqp78ydaxabjp5b64r4nmrfdfsqylrb7";
  };

  meta = {
    description = "Automatic persistence for Python objects";
    homepage = http://www.zope.org/Products/ZODB;
  };
}
