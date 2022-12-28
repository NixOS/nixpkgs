{ lib, buildPythonPackage, fetchFromGitHub, pygments }:

buildPythonPackage rec {
  pname = "jupyterlab_pygments";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "jupyterlab";
    repo = pname;
    rev = version;
    sha256 = "02lv63qalw4x6xs70n2w2p3c2cnhk91sr961wlbi77xs0g8fcman";
  };

  # no tests exist on upstream repo
  doCheck = false;

  propagatedBuildInputs = [ pygments ];

  pythonImportsCheck = [ "jupyterlab_pygments" ];

  meta = with lib; {
    description = "Jupyterlab syntax coloring theme for pygments";
    homepage = "https://github.com/jupyterlab/jupyterlab_pygments";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
