{ buildPythonPackage
, lib
, fetchPypi

# Python Packages
, pyyaml
}:

buildPythonPackage rec {
  pname = "oyaml";
  version = "0.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0rqx5cg94i4c6sj7w90g1nriiws52dffxhq554f06x0j09j09683";
  };

  doCheck = false;

  propagatedBuildInputs = [
    pyyaml
  ];

  meta = {
    description = "Python tool to find and list requirements of a Python project.";
    homepage = "https://github.com/landscapeio/requirements-detector";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      kamadorueda
    ];
  };
}
