{ lib, buildPythonPackage, fetchPypi, setuptools-scm
, tempora, six
}:

buildPythonPackage rec {
  pname = "jaraco.logging";
  version = "3.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "150dc8701207b28bc65a16f0e91c07250a8d1b9da324ce674c0e375774944f13";
  };

  pythonNamespaces = [ "jaraco" ];

  nativeBuildInputs = [ setuptools-scm ];
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
