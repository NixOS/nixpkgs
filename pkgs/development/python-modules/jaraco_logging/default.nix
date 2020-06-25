{ lib, buildPythonPackage, fetchPypi, setuptools_scm
, tempora, six
}:

buildPythonPackage rec {
  pname = "jaraco.logging";
  version = "3.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "31716fe84d3d5df39d95572942513bd4bf8ae0a478f64031eff4c2ea9e83434e";
  };

  nativeBuildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [ tempora six ];

  # test no longer packaged with pypi
  doCheck = false;

  pythonImportsCheck = [ "jaraco.logging" ];

  meta = with lib; {
    description = "Support for Python logging facility";
    homepage = "https://github.com/jaraco/jaraco.logging";
    license = licenses.mit;
  };
}
