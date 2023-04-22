{ buildPythonPackage, lib, fetchPypi }:

buildPythonPackage rec {
  pname = "fields";
  version = "5.0.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MdSqA9jUTjXfE8Qx3jUTaZfwR6kkpZfYT3vCCeG+Vyc=";
  };

  pythonImportsCheck = [ "fields" ];

  meta = with lib; {
    description = "Container class boilerplate killer";
    homepage = "https://github.com/ionelmc/python-fields";
    license = licenses.bsd2;
    maintainers = [ maintainers.sheepforce ];
  };
}
