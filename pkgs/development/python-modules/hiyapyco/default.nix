{ lib
, buildPythonPackage
, fetchFromGitHub
, pyyaml
, jinja2
}:

buildPythonPackage rec {
  pname = "hiyapyco";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "zerwes";
    repo = pname;
    rev = "refs/tags/release-${version}";
    sha256 = "sha256-v+q7MOJvRc8rzBzwf27jmuIHpZeYGDK7VbzB98qnhrQ=";
  };

  propagatedBuildInputs = [
    pyyaml
    jinja2
  ];

  postPatch = ''
    # Should no longer be needed with the next release
    # https://github.com/zerwes/hiyapyco/pull/42
    substituteInPlace setup.py \
      --replace "Jinja2>1,<3" "Jinja2>1"
  '';

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
