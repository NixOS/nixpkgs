{ buildPythonPackage, stdenv, pyyaml, pytest, enum34
, pytestpep8, pytest-flakes, fetchFromGitHub, isPy3k, lib, glibcLocales
}:

buildPythonPackage rec {
  version = "4.13.2";
  pname = "mt-940";

  # No tests in PyPI tarball
  # See https://github.com/WoLpH/mt940/pull/72
  src = fetchFromGitHub {
    owner = "WoLpH";
    repo = "mt940";
    rev = "v${version}";
    sha256 = "1lvw3qyv7qhjabcvg55br8x4pnc7hv8xzzaf6wnr8cfjg0q7dzzg";
  };

  postPatch = ''
    # No coverage report
    sed -i "/--\(no-\)\?cov/d" pytest.ini
  '';

  propagatedBuildInputs = lib.optional (!isPy3k) enum34;

  checkInputs = [ pyyaml pytestpep8 pytest-flakes pytest ];

  checkPhase = ''
    py.test
  '';

  meta = with stdenv.lib; {
    description = "A library to parse MT940 files and returns smart Python collections for statistics and manipulation";
    inherit (src.meta) homepage;
    license = licenses.bsd3;
  };
}
