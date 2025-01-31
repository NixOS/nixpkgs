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
  dependencies = [
    apprise
    aiosmtpd
    pyaml
  ];
  src = fetchFromGitHub {
    owner = "YoRyan";
    repo = "mailrise";
    tag = version;
    hash = "sha256-QgeGDQeSsfvopgBgQQsWrx036SX1FhE67LI8M8rJM/Q=";
  };
  meta = {
    description = "SMTP gateway for Apprise notifications";
    homepage = "https://github.com/YoRyan/mailrise";
    changelog = "https://github.com/YoRyan/mailrise/blob/main/CHANGELOG.rst";
    license = lib.licenses.mit;
  };
}
