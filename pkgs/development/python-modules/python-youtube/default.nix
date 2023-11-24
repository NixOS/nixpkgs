{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, dataclasses-json
, isodate
, requests
, requests-oauthlib
, pytestCheckHook
, responses
}:
buildPythonPackage rec {
  pname = "python-youtube";
  version = "0.9.2";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "sns-sdks";
    repo = "python-youtube";
    rev = "refs/tags/v${version}";
    hash = "sha256-jUs6n8j1coA37V0RTYqr7pqt+LRABieX7gbyWsXQpUM=";
  };

  postPatch = ''
    substituteInPlace pytest.ini \
      --replace "--cov=pyyoutube" "" \
      --replace "--cov-report xml" ""
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    dataclasses-json
    isodate
    requests
    requests-oauthlib
  ];

  pythonImportsCheck = [ "pyyoutube" ];

  nativeCheckInputs = [
    pytestCheckHook
    responses
  ];

  meta = with lib; {
    description = "A simple Python wrapper around for YouTube Data API";
    homepage = "https://github.com/sns-sdks/python-youtube";
    changelog = "https://github.com/sns-sdks/python-youtube/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ blaggacao ];
  };
}

