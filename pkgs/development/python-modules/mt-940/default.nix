{ buildPythonPackage, stdenv, pyyaml, pytest, enum34
, pytestpep8, pytestflakes, fetchFromGitHub, isPy3k, lib, glibcLocales
}:

buildPythonPackage rec {
  version = "4.13.0";
  pname = "mt-940";

  # No tests in PyPI tarball
  src = fetchFromGitHub {
    owner = "WoLpH";
    repo = "mt940";
    rev = "v${version}";
    sha256 = "0p6z4ipj0drph3ryn8mnb3xn0vjfv54y1c5w5i9ixrxwz48h6bga";
  };

  postPatch = ''
    # No coverage report
    sed -i "/--\(no-\)\?cov/d" pytest.ini
  '';

  propagatedBuildInputs = lib.optional (!isPy3k) enum34;

  LC_ALL="en_US.UTF-8";

  checkInputs = [ pyyaml pytestpep8 pytestflakes pytest glibcLocales ];

  checkPhase = ''
    py.test
  '';

  meta = with stdenv.lib; {
    description = "A library to parse MT940 files and returns smart Python collections for statistics and manipulation";
    inherit (src.meta) homepage;
    license = licenses.bsd3;
  };
}
