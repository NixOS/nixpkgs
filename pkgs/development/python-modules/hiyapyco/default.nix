{ lib
, buildPythonPackage
, fetchFromGitHub
, pyyaml
, jinja2
}:

buildPythonPackage rec {
  pname = "hiyapyco";
  version = "0.5.4";

  src = fetchFromGitHub {
    owner = "zerwes";
    repo = pname;
    rev = "refs/tags/release-${version}";
    hash = "sha256-hKTqdclWMKTGeRtQuNj0gYdiGFovFh5FQ2rRjCgbvBM=";
  };

  propagatedBuildInputs = [
    pyyaml
    jinja2
  ];

  checkPhase = ''
    set -e
    find test -name 'test_*.py' -exec python {} \;
  '';

  pythonImportsCheck = [ "hiyapyco" ];

  meta = with lib; {
    description = "Python library allowing hierarchical overlay of config files in YAML syntax";
    homepage = "https://github.com/zerwes/hiyapyco";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ veehaitch ];
  };
}
