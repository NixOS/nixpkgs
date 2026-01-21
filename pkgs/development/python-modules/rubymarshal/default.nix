{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
}:

buildPythonPackage rec {
  pname = "rubymarshal";
  version = "1.2.10";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-iZtG5khSANCHhY/1YpWIF2T/Umj2/fAbfsxOTgPT7Xw=";
  };

  build-system = [ poetry-core ];

  # pypi doesn't distribute tests
  doCheck = false;

  pythonImportsCheck = [ "rubymarshal" ];

  meta = {
    description = "Read and write Ruby-marshalled data";
    homepage = "https://github.com/d9pouces/RubyMarshal/";
    license = lib.licenses.wtfpl;
    maintainers = with lib.maintainers; [ ryantm ];
  };
}
