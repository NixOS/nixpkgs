{ buildPythonPackage
, fetchPypi
, lib
, mutagen
, six
}:

buildPythonPackage rec {
  pname = "mediafile";
  version = "0.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "878ccc378b77f2d6c175abea135ea25631f28c722e01e1a051924d962ebea165";
  };

  propagatedBuildInputs = [ mutagen six ];

  meta = with lib; {
    description = "MediaFile is a simple interface to the metadata tags for many audio file formats.";
    homepage = "https://github.com/beetbox/mediafile";
    license = licenses.mit;
    maintainers = with maintainers; [ lovesegfault ];
  };
}
