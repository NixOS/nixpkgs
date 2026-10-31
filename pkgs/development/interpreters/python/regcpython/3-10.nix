{ config, lib, pkgs, ... }:

(pkgs.python310.overrideAttrs (old: {
  src = pkgs.fetchFromGitHub {
    owner = "zq1997";
    repo = "RegCPython";
    rev = "a589237a3e306ab9c6c9a24e2971e850f7ebacb6";
    sha256 = "sha256-baHSTh0JRuAiG0HORk0NlCDmIB4njW00tPNOF0lXu60=";
  };
  version = "3.10.11_regc";
  meta = {
    description = "A register-based version of CPython";
    longDescription = ''
      - compile it as you would compile CPython,
      - install it like you would install CPython,
      - use it as you you would use CPython,
      - but RegCPython is faster.
    '';
    homepage = "https://github.com/zq1997/RegCPython";
    changelog = "https://github.com/zq1997/RegCPython/commit/a589237a3e306ab9c6c9a24e2971e850f7ebacb6";
    maintainers = with lib.maintainers; [ ProducerMatt ];
  };
})).override {
  sourceVersion = {
    major = "3";
    minor = "10";
    path = "11";
    patch = "";
    suffix = "_regc";
  };
}
