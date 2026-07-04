{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  pyloggermanager,
  requests,
  pym3u8downloader, # For package tests
}:

buildPythonPackage rec {
  pname = "pym3u8downloader";
  version = "0.1.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "coldsofttech";
    repo = "pym3u8downloader";
    tag = version;
    hash = "sha256-VfNzHysvEVUNx8OK28v2l3QYTMn0ydE/LH+DBXpLfE8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pyloggermanager
    requests
  ];

  pythonImportsCheck = [ "pym3u8downloader" ];

  doCheck = false;

  passthru = {
    tests = {
      pytest = pym3u8downloader.overridePythonAttrs (previousPythonAttrs: {
        TEST_SERVER_PORT = "8000";

        postPatch = previousPythonAttrs.postPatch or "" + ''
          # Patch test data location
          substituteInPlace tests/commonclass.py \
            --replace-fail \
              "f'https://raw.githubusercontent.com/coldsofttech/pym3u8downloader/{branch_name}/tests/files'" \
              "'http://localhost:$TEST_SERVER_PORT/tests/files'"
          # Patch the `is_internet_connected()` method
          substituteInPlace pym3u8downloader/__main__.py \
            --replace-fail "'http://www.github.com'" "'http://localhost:$TEST_SERVER_PORT'"
        '';

        doCheck = true;

        nativeCheckInputs = [ pytestCheckHook ];

        preCheck = previousPythonAttrs.preCheck or "" + ''
          python3 -m http.server "$TEST_SERVER_PORT" &
          TEST_SERVER_PID="$!"
        '';

        postCheck = previousPythonAttrs.postCheck or "" + ''
          kill -s TERM "$TEST_SERVER_PID"
        '';
      });
    };
  };

  meta = {
    description = "Python class to download and concatenate video files from M3U8 playlists";
    longDescription = ''
      M3U8 Downloader is a Python class designed to
      download and concatenate video files from M3U8 playlists.
      This class provides functionality to handle M3U8 playlist files,
      download video segments,
      concatenate them into a single video file,
      and manage various error conditions.
    '';
    homepage = "https://github.com/coldsofttech/pym3u8downloader";
    changelog = "https://github.com/coldsofttech/pym3u8downloader/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ShamrockLee ];
  };
}
