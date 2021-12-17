{ lib, buildPythonPackage, fetchFromGitHub, isPy3k }:

buildPythonPackage rec {
  pname = "precis-i18n";
  version = "1.0.3";

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "byllyfish";
    repo = "precis_i18n";
    rev = "v${version}";
    hash = "sha256-pBmllX1RVdFnZsDSW7Hh5uVqK2d++kcp1NQLN/phXdU=";
  };

  meta = {
    homepage = "https://github.com/byllyfish/precis_i18n";
    description = "Internationalized usernames and passwords";
    license = lib.licenses.mit;
  };
}
