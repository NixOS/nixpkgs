{ lib, buildPythonPackage, fetchPypi, lxml, sqlalchemy }:

buildPythonPackage rec {
  pname = "IMDbPY";
  version = "2020.9.25";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1p3j9j1jcgbw4626cvgpryhvczy9gzlg0laz6lflgq17m129gin2";
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
