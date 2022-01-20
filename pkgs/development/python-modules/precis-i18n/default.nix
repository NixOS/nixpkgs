{ lib, buildPythonPackage, fetchFromGitHub, isPy3k }:

buildPythonPackage rec {
  pname = "precis-i18n";
  version = "1.0.4";

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "byllyfish";
    repo = "precis_i18n";
    rev = "v${version}";
    hash = "sha256-90yNusUyz8qJi7WWYIFhHzrpvu1TqxfpT+lv2CVhSR8=";
  };

  meta = {
    homepage = "https://github.com/byllyfish/precis_i18n";
    description = "Internationalized usernames and passwords";
    license = lib.licenses.mit;
  };
}
