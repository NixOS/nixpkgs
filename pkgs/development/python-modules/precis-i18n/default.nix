{ lib, buildPythonPackage, fetchFromGitHub, isPy3k }:

buildPythonPackage rec {
  pname = "precis-i18n";
  version = "1.0.2";

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "byllyfish";
    repo = "precis_i18n";
    rev = "v${version}";
    hash = "sha256:1r9pah1kgik6valf15ac7ybw0szr92cq84kwjvm6mq3z46j1pmkr";
  };

  meta = {
    homepage = "https://github.com/byllyfish/precis_i18n";
    description = "Internationalized usernames and passwords";
    license = lib.licenses.mit;
  };
}
