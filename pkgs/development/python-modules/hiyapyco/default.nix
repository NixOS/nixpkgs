{ lib
, buildPythonPackage
, fetchFromGitHub
, pyyaml
, jinja2
}:

buildPythonPackage rec {
  pname = "hiyapyco";
  version = "0.4.16";

  src = fetchFromGitHub {
    owner = "zerwes";
    repo = pname;
    rev = "release-${version}";
    sha256 = "1ams9dp05yhgbg6255wrjgchl2mqg0s34d8b8prvql9lsh59s1fj";
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
