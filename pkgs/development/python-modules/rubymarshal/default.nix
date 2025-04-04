{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
}:

buildPythonPackage rec {
  pname = "rubymarshal";
  version = "1.2.9";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-OqTbHV2duO4SmP6O9+tfaSD7fKOJ/PmzX5dUW9eoBBg=";
  };

  build-system = [ poetry-core ];

  # pypi doesn't distribute tests
  doCheck = false;

  pythonImportsCheck = [ "rubymarshal" ];

  meta = with lib; {
    description = "Read and write Ruby-marshalled data";
    homepage = "https://github.com/d9pouces/RubyMarshal/";
    license = licenses.wtfpl;
    maintainers = with maintainers; [ ryantm ];
  };
}
