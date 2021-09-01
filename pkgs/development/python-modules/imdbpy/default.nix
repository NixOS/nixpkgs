{ lib, buildPythonPackage, fetchPypi, lxml, sqlalchemy }:

buildPythonPackage rec {
  pname = "IMDbPY";
  version = "2021.4.18";

  src = fetchPypi {
    inherit pname version;
    sha256 = "af57f03638ba3b8ab3d696bfef0eeaf6414385c85f09260aba0a16b32174853f";
  };

  patches = [ ./sql_error.patch ]; # Already fixed in master, but not yet in the current release. This can be removed upon the next version update

  propagatedBuildInputs = [ lxml sqlalchemy ];

  doCheck = false; # Tests require networking, and https://github.com/alberanid/imdbpy/issues/240
  pythonImportsCheck = [ "imdb" ];

  meta = with lib; {
    homepage = "https://imdbpy.github.io/";
    description = "A Python package for retrieving and managing the data of the IMDb database";
    maintainers = [ maintainers.ivar ];
    license = licenses.gpl2Only;
  };
}
