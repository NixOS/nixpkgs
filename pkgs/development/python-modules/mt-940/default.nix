{ buildPythonPackage, stdenv, pyyaml, pytest, enum34
, pytestpep8, pytestflakes, fetchFromGitHub, isPy3k, lib, glibcLocales
}:

buildPythonPackage rec {
  version = "4.12.2";
  pname = "mt-940";

  src = fetchFromGitHub {
    owner = "WoLpH";
    repo = "mt940";
    rev = "v${version}";
    sha256 = "0l7q8v00dhpbc9mh6baaaqc55kf44rszygx28dq3pwp5b5x33nir";
  };

  postPatch = ''
    # No coverage report
    sed -i "/--\(no-\)\?cov/d" pytest.ini
  '';

  propagatedBuildInputs = lib.optional (!isPy3k) enum34;

  LC_ALL="en_US.UTF-8";

  checkInputs = [ pyyaml pytestpep8 pytestflakes pytest glibcLocales ];

  # See https://github.com/WoLpH/mt940/issues/64 for the disabled test
  checkPhase = ''
    py.test -k "not mt940.models.FixedOffset"
  '';

  meta = with stdenv.lib; {
    description = "A library to parse MT940 files and returns smart Python collections for statistics and manipulation";
    inherit (src.meta) homepage;
    license = licenses.bsd3;
  };
}
