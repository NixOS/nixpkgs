{
  lib,
  buildPythonPackage,
  setuptools,
  fetchPypi,
  scipy,
  pandas,
}:

buildPythonPackage rec {

  pname = "gower";
  version = "0.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-NN21FY8Oi/ugk9yga5+Ie9okSZjRCvKjrYx0pu+htfY=";
  };

  patchPhase = ''
    rm pyproject.toml
  '';

  dependencies = [
    setuptools
    scipy
    pandas
  ];

  meta = with lib; {
    description = "Gower's distance calculation in Python.";
    homepage = "https://github.com/wwwjk366/gower";
    license = licenses.mit;
    maintainers = with maintainers; [ b-rodrigues ];
  };
}
