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
  version = "0.9.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "sns-sdks";
    repo = "python-youtube";
    rev = "v${version}";
    hash = "sha256-uimipYgf8nfYd1J/K6CStbzIkQiRSosu7/yOfgXYCks=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "poetry.masonry.api" "poetry.core.masonry.api"
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

  disabledTests = [
    # On both tests, upstream compares a string to an integer

    /*
      python3.10-python-youtube> >       self.assertEqual(m.viewCount, "160361638")
      python3.10-python-youtube> E       AssertionError: 160361638 != '160361638'
      python3.10-python-youtube> tests/models/test_channel.py:62: AssertionError
    */
    "testChannelStatistics"

    /*
      python3.10-python-youtube> >       self.assertEqual(m.viewCount, "8087")
      python3.10-python-youtube> E       AssertionError: 8087 != '8087'
      python3.10-python-youtube> tests/models/test_videos.py:76: AssertionError
    */
    "testVideoStatistics"
  ];

  meta = with lib; {
    description = "A simple Python wrapper around for YouTube Data API";
    homepage = "https://github.com/sns-sdks/python-youtube";
    changelog = "https://github.com/sns-sdks/python-youtube/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ blaggacao ];
  };
}

