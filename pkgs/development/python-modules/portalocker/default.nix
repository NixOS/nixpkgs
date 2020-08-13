{ lib, buildPythonPackage, fetchPypi, fetchpatch
, sphinx
, pytest
, pytestcov
, pytest-flake8
}:

buildPythonPackage rec {
  version = "1.7.0";
  pname = "portalocker";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1p32v16va780mjjdbyp3v702aqg5s618khlila7bdyynis1n84q9";
  };

  patches = [
    # remove pytest-flakes from test dependencies
    # merged into master, remove > 1.7.0 release
    (fetchpatch {
      url = "https://github.com/WoLpH/portalocker/commit/42e4c0a16bbc987c7e33b5cbc7676a63a164ceb5.patch";
      sha256 = "01mlr41nhh7mh3qhqy5fhp3br4nps745iy4ns9fjcnm5xhabg5rr";
      excludes = [ "pytest.ini" ];
    })
  ];

  checkInputs = [
    sphinx
    pytest
    pytestcov
    pytest-flake8
  ];

  meta = with lib; {
    description = "A library to provide an easy API to file locking";
    homepage = "https://github.com/WoLpH/portalocker";
    license = licenses.psfl;
    maintainers = with maintainers; [ jonringer ];
    platforms = platforms.unix; # Windows has a dependency on pypiwin32
  };
}
