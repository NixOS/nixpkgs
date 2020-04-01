{ stdenv, buildPythonPackage, fetchPypi,
  matplotlib, shapely
}:

buildPythonPackage rec {
  pname = "descartes";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0nq36w9ylvfwmwn5qd9c8fsp2jzsqpmy4xcr6pzxcpmg8qhm0nhk";
  };

  propagatedBuildInputs = [
    matplotlib
    shapely
  ];

  meta = with stdenv.lib; {
    description = "Python library to use Shapely or GeoJSON objects as matplotlib paths";
    homepage = "https://bitbucket.org/sgillies/descartes/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ knedlsepp ];
  };
}
