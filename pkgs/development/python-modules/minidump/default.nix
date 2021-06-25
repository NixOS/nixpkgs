{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "minidump";
  version = "0.0.18";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-uf4KZc9C1gWRgHu4ttk1fpL2pG8oUb79uvCIlHItB/8=";
  };

  # Upstream doesn't have tests
  doCheck = false;
  pythonImportsCheck = [ "minidump" ];

  meta = with lib; {
    description = "Python library to parse and read Microsoft minidump file format";
    homepage = "https://github.com/skelsec/minidump";
    license = with licenses; [ mit ];
    maintainers = [ maintainers.fab ];
  };
}
