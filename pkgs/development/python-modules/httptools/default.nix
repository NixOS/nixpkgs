{ lib
, buildPythonPackage
, fetchPypi
, isPy27
}:

buildPythonPackage rec {
  pname = "httptools";
  version = "0.5.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-KVh0hhwXP5EBlgu6MyQpu3ftTc2M31zumSLrAOT2vAk=";
  };

  # tests are not included in pypi tarball
  doCheck = false;

  pythonImportsCheck = [ "httptools" ];

  meta = with lib; {
    description = "A collection of framework independent HTTP protocol utils";
    homepage = "https://github.com/MagicStack/httptools";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
