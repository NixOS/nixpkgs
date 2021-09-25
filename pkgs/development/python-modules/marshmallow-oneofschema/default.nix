{ lib, buildPythonPackage, fetchPypi, marshmallow, setuptools }:

buildPythonPackage rec {
  pname = "marshmallow-oneofschema";
  version = "3.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "62cd2099b29188c92493c2940ee79d1bf2f2619a71721664e5a98ec2faa58237";
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
