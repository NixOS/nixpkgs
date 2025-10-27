{
  lib,
  python3Packages,
  fetchFromGitHub,
  ffmpeg,
}:

python3Packages.buildPythonApplication rec {
  pname = "yutto";
  version = "2.1.0";
  pyproject = true;

  pythonRelaxDeps = true;

  src = fetchFromGitHub {
    owner = "yutto-dev";
    repo = "yutto";
    tag = "v${version}";
    hash = "sha256-A9LM+hdev9/vH4HV2DUhpiA2XqvXYxtSUt2dyUnZwsU=";
  };

  build-system = with python3Packages; [ uv-build ];

  dependencies =
    with python3Packages;
    [
      aiofiles
      biliass
      dict2xml
      httpx
      typing-extensions
      pydantic
      returns
    ]
    ++ (with httpx.optional-dependencies; http2 ++ socks);

  preFixup = ''
    makeWrapperArgs+=(--prefix PATH : ${lib.makeBinPath [ ffmpeg ]})
  '';

  pythonImportsCheck = [ "yutto" ];

  meta = with lib; {
    description = "Bilibili downloader";
    homepage = "https://github.com/yutto-dev/yutto";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ linsui ];
    mainProgram = "yutto";
  };
}
