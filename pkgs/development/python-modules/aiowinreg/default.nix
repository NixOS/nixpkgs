{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, winacl
}:

buildPythonPackage rec {
  pname = "aiowinreg";
  version = "0.0.5";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "096663ec3db35fdc7ccc1c2d0d64a11cf64f4baa48955088e42b6a649ce418a5";
  };

  propagatedBuildInputs = [ winacl ];

  # Project doesn't have tests
  doCheck = false;
  pythonImportsCheck = [ "aiowinreg" ];

  meta = with lib; {
    description = "Python module to parse the registry hive";
    homepage = "https://github.com/skelsec/aiowinreg";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
