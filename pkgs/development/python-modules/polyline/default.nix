{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, pytestCheckHook
, pythonOlder
, setuptools
, wheel
}:

buildPythonPackage rec {
  pname = "polyline";
  version = "2.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "frederickjansen";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-e9ZDqcS3MaMlXi2a2JHI6NtRPqIV7rjsucGXEH6V8LA=";
  };

  patches = [
    # https://github.com/frederickjansen/polyline/pull/15
    (fetchpatch {
      name = "relax-build-dependencies.patch";
      url = "https://github.com/frederickjansen/polyline/commit/cb9fc80606c33dbbcaa0d94de25ae952358443b6.patch";
      hash = "sha256-epg2pZAG+9QuICa1ms+/EO2DDmYEz+KEtxxnvG7rsWY=";
    })
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace " --cov=polyline --cov-report term-missing" ""
  '';

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "polyline"
  ];

  meta = with lib; {
    description = "Python implementation of Google's Encoded Polyline Algorithm Format";
    longDescription = ''
      polyline is a Python implementation of Google's Encoded Polyline Algorithm Format. It is
      essentially a port of https://github.com/mapbox/polyline.
    '';
    homepage = "https://github.com/frederickjansen/polyline";
    changelog = "https://github.com/frederickjansen/polyline/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ersin ];
  };
}
