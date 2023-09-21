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
  version = "0.9.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "sns-sdks";
    repo = "python-youtube";
    rev = "v${version}";
    hash = "sha256-PbPdvUv7I9NKW6w4OJbiUoRNVJ1SoXychSXBH/y5nzY=";
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

