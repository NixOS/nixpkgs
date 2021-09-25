{ lib
, buildPythonPackage
, fetchPypi
, bitlist
}:

buildPythonPackage rec {
  pname = "fountains";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "47c28e598cc3a723327daee28c757de3a40f4d8eb48e6be37081932c1d00fa6f";
  };

  propagatedBuildInputs = [
    bitlist
  ];

  # Project has no test
  doCheck = false;

  pythonImportsCheck = [ "fountains" ];

  meta = with lib; {
    description = "Python library for generating and embedding data for unit testing";
    homepage = "https://github.com/reity/fountains";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
