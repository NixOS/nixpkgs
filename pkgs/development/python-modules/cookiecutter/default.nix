{ lib, buildPythonPackage, fetchPypi, isPyPy
<<<<<<< HEAD
, pytest, pytest-cov, pytest-mock, freezegun, safety, pre-commit
, jinja2, future, binaryornot, click, jinja2-time, requests
, python-slugify
, pyyaml
, arrow
, rich
=======
, pytest, pytest-cov, pytest-mock, freezegun
, jinja2, future, binaryornot, click, jinja2-time, requests
, python-slugify
, pyyaml
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "cookiecutter";
<<<<<<< HEAD
  version = "2.3.0";
=======
  version = "2.1.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # not sure why this is broken
  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-lCp5SYF0f21/Q51uSdOdyRqaZBKDYUFgyTxHTHLCliE=";
  };

  nativeCheckInputs = [
    pytest
    pytest-cov
    pytest-mock
    freezegun
    safety
    pre-commit
  ];
=======
    hash = "sha256-85gr6NnFPawSYYZAE/3sf4Ov0uQu3m9t0GnF4UnFQNU=";
  };

  nativeCheckInputs = [ pytest pytest-cov pytest-mock freezegun ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  propagatedBuildInputs = [
    binaryornot
    jinja2
    click
    pyyaml
    jinja2-time
    python-slugify
    requests
<<<<<<< HEAD
    arrow
    rich
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  # requires network access for cloning git repos
  doCheck = false;
  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    homepage = "https://github.com/audreyr/cookiecutter";
    description = "A command-line utility that creates projects from project templates";
    license = licenses.bsd3;
    maintainers = with maintainers; [ kragniz ];
  };
}
