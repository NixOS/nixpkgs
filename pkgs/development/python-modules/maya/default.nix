{ lib, fetchPypi, fetchpatch, buildPythonPackage
, dateparser, humanize, pendulum, ruamel_yaml, tzlocal }:

buildPythonPackage rec {
  pname = "maya";
  version = "0.3.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1x88k4irpckvd7jf2yvqjw1s52hjqbxym1r1d928yb3fkj7rvlxs";
  };

  patches = [
    (fetchpatch {
      # https://github.com/kennethreitz/maya/issues/112
      # Merged, so should be in next release.
      url = "https://github.com/kennethreitz/maya/commit/f69a93b1103130139cdec30511777823957fb659.patch";
      sha256 = "152ba7amv9dhhx1wcklfalsdzsxggik9f7rsrikms921lq9xqc8h";
    })
  ];

  propagatedBuildInputs = [ dateparser humanize pendulum ruamel_yaml tzlocal ];

  # No tests
  doCheck = false;

  meta = with lib; {
    description = "Datetimes for Humans";
    homepage = "https://github.com/kennethreitz/maya";
    license = licenses.mit;
  };
}
