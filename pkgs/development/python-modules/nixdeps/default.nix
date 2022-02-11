{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, isPy27
}:

buildPythonPackage rec {
  pname = "nixdeps";
  version = "1.0.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0rjwjz3qzifp6kh11p7whgs4dm44d07n28phw03gwfisqi4k2h43";
  };

  pythonImportsCheck = [ "nixdeps.setuptools" ];
  propagatedBuildInputs = [ setuptools ];

  meta = with lib; {
    description = "A setuptools entrypoint to store dependencies on Nix packages at build-time";
    homepage = "https://github.com/catern/rsyscall/tree/master/nixdeps";
    license = licenses.mit;
    maintainers = with maintainers; [ catern ];
  };
}

