{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pygments,
}:

buildPythonPackage rec {
  pname = "pygments-better-html";
  version = "0.1.5";
  pyproject = true;

  src = fetchPypi {
    pname = "pygments_better_html";
    inherit version;
    hash = "sha256-SLAe5ubIGEchUNoHCct6CWisBja3WNEfpE48v9CTzPQ=";
  };

  build-system = [ setuptools ];

  dependencies = [ pygments ];

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "pygments_better_html" ];

  meta = with lib; {
    homepage = "https://github.com/Kwpolska/pygments_better_html";
    description = "Improved line numbering for Pygments’ HTML formatter";
    license = licenses.bsd3;
    maintainers = with maintainers; [ hexa ];
  };
}
