{ lib
, buildPythonPackage
, fetchFromGitHub
, pyyaml
, jinja2
}:

buildPythonPackage rec {
  pname = "HiYaPyCo";
  version = "0.4.16";

  src = fetchFromGitHub {
    owner = "zerwes";
    repo = pname;
    rev = "release-${version}";
    sha256 = "1ams9dp05yhgbg6255wrjgchl2mqg0s34d8b8prvql9lsh59s1fj";
  };

  propagatedBuildInputs = [ pyyaml jinja2 ];

  checkPhase = ''
    set -e
    find test -name 'test_*.py' -exec python {} \;
  '';

  meta = with lib; {
    description = "A simple python lib allowing hierarchical overlay of config files in YAML syntax, offering different merge methods and variable interpolation based on jinja2.";
    homepage = "https://github.com/zerwes/hiyapyco";
    license = licenses.gpl3;
    maintainers = with maintainers; [ veehaitch ];
  };
}
