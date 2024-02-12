{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "podcastparser";
  version = "0.6.10";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "gpodder";
    repo = "podcastparser";
    rev = "refs/tags/${version}";
    hash = "sha256-P9wVyxTO0nz/DfuBhCE+VjhH1uYx4jBd30Ca26yBzbo=";
  };

  postPatch = ''
    substituteInPlace pytest.ini \
      --replace "--cov=podcastparser --cov-report html --doctest-modules" ""
  '';

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "podcastparser"
  ];

  meta = with lib; {
    description = "Module to parse podcasts";
    homepage = "http://gpodder.org/podcastparser/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ mic92 ];
  };
}
