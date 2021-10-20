{ lib, fetchPypi, buildPythonPackage
, importlib-metadata, importlib-resources, six, traits
}:

buildPythonPackage rec {
  pname = "pyface";
  version = "7.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a7031ec4cfff034affc822e47ff5e6c1a0272e576d79465cdbbe25f721740322";
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
