{ lib, fetchPypi, buildPythonPackage
, importlib-metadata, importlib-resources, six, traits
}:

buildPythonPackage rec {
  pname = "pyface";
  version = "7.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-r8Awj9dOYPWxh1Ar2JK/nhuY8hAGFO4+6yr9yq7Pb6s=";
  };

  propagatedBuildInputs = [ importlib-metadata importlib-resources six traits ];

  doCheck = false; # Needs X server

  pythonImportsCheck = [ "pyface" ];

  meta = with lib; {
    description = "Traits-capable windowing framework";
    homepage = "https://github.com/enthought/pyface";
    maintainers = with maintainers; [ knedlsepp ];
    license = licenses.bsdOriginal;
  };
}
