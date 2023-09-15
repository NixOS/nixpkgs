{ lib, fetchPypi, fetchpatch, buildPythonPackage
, dateparser, humanize, pendulum, ruamel-yaml, tzlocal }:

buildPythonPackage rec {
  pname = "maya";
  version = "0.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-f1PgbVoSNhPc58Jwy8ZHZDppQlkNunoZ7DYZTQM4w/Q=";
  };

  patches = [
    (fetchpatch {
      # https://github.com/kennethreitz/maya/issues/112
      # Merged, so should be in next release.
      url = "https://github.com/kennethreitz/maya/commit/f69a93b1103130139cdec30511777823957fb659.patch";
      sha256 = "152ba7amv9dhhx1wcklfalsdzsxggik9f7rsrikms921lq9xqc8h";
    })
  ];

  propagatedBuildInputs = [ dateparser humanize pendulum ruamel-yaml tzlocal ];

  # No tests
  doCheck = false;

  meta = with lib; {
    description = "Datetimes for Humans";
    homepage = "https://github.com/kennethreitz/maya";
    license = licenses.mit;
  };
}
