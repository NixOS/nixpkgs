{
  buildPythonPackage,
  lib,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "fields";
  version = "5.0.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MdSqA9jUTjXfE8Qx3jUTaZfwR6kkpZfYT3vCCeG+Vyc=";
  };

  pythonImportsCheck = [ "fields" ];

  meta = {
    description = "Container class boilerplate killer";
    homepage = "https://github.com/ionelmc/python-fields";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.sheepforce ];
  };
}
