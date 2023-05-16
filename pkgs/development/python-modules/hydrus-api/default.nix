{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, poetry-core
, requests
}:

buildPythonPackage rec {
  pname = "hydrus-api";
<<<<<<< HEAD
  version = "5.0.1";
=======
  version = "5.0.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    pname = "hydrus_api";
    inherit version;
<<<<<<< HEAD
    hash = "sha256-3Roeab9/woGF/aZYm9nbqrcyYN8CKA1k66cTRxx6jM4=";
=======
    hash = "sha256-s6gS1rVcbg7hcE63hGdPhJCcgS4N4d58MpSrECAfe0U=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    substituteInPlace pyproject.toml --replace \
      "poetry.masonry.api" \
      "poetry.core.masonry.api"
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    requests
  ];

  pythonImportsCheck = [ "hydrus_api" ];

  # There are no unit tests
  doCheck = false;

  meta = with lib; {
    description = "Python module implementing the Hydrus API";
    homepage = "https://gitlab.com/cryzed/hydrus-api";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ dandellion ];
  };
}
