{
  lib,
  buildPythonPackage,
  fetchPypi,
  hypothesis,
  isPy3k,
}:

buildPythonPackage rec {
  pname = "rubymarshal";
  version = "1.2.7";
  format = "setuptools";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-lKqE+kI5P3c8ghX6tnm9O3K72595MWQ9NnIYTN6Zgdk=";
  };

  propagatedBuildInputs = [ hypothesis ];

  # pypi doesn't distribute tests
  doCheck = false;

  pythonImportsCheck = [ "rubymarshal" ];

  meta = with lib; {
    homepage = "https://github.com/d9pouces/RubyMarshal/";
    description = "Read and write Ruby-marshalled data";
    license = licenses.wtfpl;
    maintainers = [ maintainers.ryantm ];
  };
}
