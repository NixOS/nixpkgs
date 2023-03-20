{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, poetry-core
, requests
}:

buildPythonPackage rec {
  pname = "hydrus-api";
  version = "5.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    pname = "hydrus_api";
    inherit version;
    hash = "sha256-s6gS1rVcbg7hcE63hGdPhJCcgS4N4d58MpSrECAfe0U=";
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
