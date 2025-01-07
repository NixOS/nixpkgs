{
  lib,
  buildPythonPackage,
  fetchPypi,
  pygments,
  isPy3k,
}:

buildPythonPackage rec {
  pname = "pygments_better_html";
  version = "0.1.5";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-SLAe5ubIGEchUNoHCct6CWisBja3WNEfpE48v9CTzPQ=";
  };

  propagatedBuildInputs = [ pygments ];

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "pygments_better_html" ];

  meta = {
    homepage = "https://github.com/Kwpolska/pygments_better_html";
    description = "Improved line numbering for Pygments’ HTML formatter";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
