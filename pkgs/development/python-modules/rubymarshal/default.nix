{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  isPy3k,
}:

buildPythonPackage rec {
  pname = "rubymarshal";
  version = "1.2.9";
  pyproject = true;
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-OqTbHV2duO4SmP6O9+tfaSD7fKOJ/PmzX5dUW9eoBBg=";
  };

  build-system = [ poetry-core ];

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
