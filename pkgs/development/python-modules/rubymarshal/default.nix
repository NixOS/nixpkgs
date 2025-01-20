{
  lib,
  buildPythonPackage,
  fetchPypi,
  hypothesis,
  isPy3k,
}:

buildPythonPackage rec {
  pname = "rubymarshal";
  version = "1.2.8";
  format = "setuptools";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-8+8KxCjsawlFXd1Bgq/8jY0TSB9l8UHaNMkcqfoz7hs=";
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
