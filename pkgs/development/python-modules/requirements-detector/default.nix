{ buildPythonPackage
, lib
, fetchPypi

# Python Packages
, astroid
}:

buildPythonPackage rec {
  pname = "requirements-detector";
  version = "0.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0cc9s3c3p5w6ndwm0hmxj5mqr14n8niypqrjzwx6dhxpx0j4pg4z";
  };

  doCheck = false;

  propagatedBuildInputs = [
    astroid
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
