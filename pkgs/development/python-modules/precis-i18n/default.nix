{ lib, buildPythonPackage, fetchPypi, isPy3k }:

buildPythonPackage rec {
  pname = "precis-i18n";
  version = "1.0.0";

  disabled = !isPy3k;

  src = fetchPypi {
    pname = "precis_i18n";
    inherit version;
    sha256 = "0gjhvwd8aifx94rl1ag08vlmndyx2q3fkyqb0c4i46x3p2bc2yi2";
  };

  meta = {
    homepage = https://github.com/byllyfish/precis_i18n;
    description = "Internationalized usernames and passwords";
    license = lib.licenses.mit;
  };
}
