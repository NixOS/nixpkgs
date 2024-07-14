{
  lib,
  buildPythonPackage,
  fetchPypi,
  attrs,
  pbr,
}:

buildPythonPackage rec {
  pname = "sarif-om";
  version = "1.0.4";
  format = "setuptools";

  src = fetchPypi {
    pname = "sarif_om";
    inherit version;
    hash = "sha256-zV9BazCD4A1AKpLkSaf/Z69G8RJBBz7qBGGAKjta75g=";
  };

  nativeBuildInputs = [ pbr ];

  propagatedBuildInputs = [ attrs ];

  pythonImportsCheck = [ "sarif_om" ];

  # no tests included with tarball
  doCheck = false;

  meta = with lib; {
    description = "Classes implementing the SARIF 2.1.0 object model";
    homepage = "https://github.com/microsoft/sarif-python-om";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
