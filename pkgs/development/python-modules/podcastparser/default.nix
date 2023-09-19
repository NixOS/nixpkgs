{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "podcastparser";
  version = "0.6.10";

  src = fetchFromGitHub {
    owner = "gpodder";
    repo = "podcastparser";
    rev = "refs/tags/${version}";
    hash = "sha256-P9wVyxTO0nz/DfuBhCE+VjhH1uYx4jBd30Ca26yBzbo=";
  };

  postPatch = ''
    rm pytest.ini
  '';

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "podcastparser is a simple, fast and efficient podcast parser written in Python.";
    homepage = "http://gpodder.org/podcastparser/";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ mic92 ];
  };
}
