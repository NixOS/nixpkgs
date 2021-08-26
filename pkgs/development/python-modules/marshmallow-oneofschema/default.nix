{ lib, buildPythonPackage, fetchPypi, marshmallow, setuptools }:

buildPythonPackage rec {
  pname = "marshmallow-oneofschema";
  version = "2.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0s0yr7nv06sfgxglghl2vq74g3m49j60k1hi2qzfsv4bj8hvs35k";
  };

  propagatedBuildInputs = [ marshmallow setuptools ];

  pythonImportsCheck = [ "marshmallow_oneofschema" ];

  meta = with lib; {
    homepage = "https://github.com/marshmallow-code/marshmallow-oneofschema";
    description = "Marshmallow library extension that allows schema (de)multiplexing";
    license = licenses.mit;
    maintainers = [ maintainers.ivan-tkatchev ];
  };
}
