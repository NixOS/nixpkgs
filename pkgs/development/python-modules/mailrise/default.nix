{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  apprise,
  aiosmtpd,
  pyaml,
}:
buildPythonPackage rec {
  pname = "mailrise";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "YoRyan";
    repo = "mailrise";
    tag = version;
    hash = "sha256-QgeGDQeSsfvopgBgQQsWrx036SX1FhE67LI8M8rJM/Q=";
  };

  dependencies = [
    apprise
    aiosmtpd
    pyaml
  ];

  meta = {
    description = "SMTP gateway for Apprise notifications";
    homepage = "https://github.com/YoRyan/mailrise";
    changelog = "https://github.com/YoRyan/mailrise/blob/main/CHANGELOG.rst";
    maintainers = with meta.maintainers; [ kr-nn ];
    license = lib.licenses.mit;
  };
}
