{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, pyyaml
, twine
}:

buildPythonPackage rec {
  pname = "pycomposefile";
  version = "0.0.31";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    extension = "tar.gz";
    hash = "sha256-SYul81giQLUM1FdgfabKJyrbSu4xdoaWblcE87ZbBwg=";
  };

  nativeBuildInput = [
    setuptools
  ];

  propagatedBuildInputs = [
    pyyaml
    twine
  ];

  doCheck = false; # tests are broken

  meta = with lib; {
    description = "Python library for structured deserialization of Docker Compose files";
    homepage = "https://github.com/smurawski/pycomposefile";
    license = licenses.mit;
    maintainers = with maintainers; [ mdarocha ];
  };
}
