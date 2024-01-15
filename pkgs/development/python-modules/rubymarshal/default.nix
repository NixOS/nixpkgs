{ lib, buildPythonPackage, fetchPypi, hypothesis, isPy3k }:

buildPythonPackage rec {
  pname = "rubymarshal";
  version = "1.2.7";
  format = "setuptools";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "94aa84fa42393f773c8215fab679bd3b72bbdb9f7931643d3672184cde9981d9";
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
