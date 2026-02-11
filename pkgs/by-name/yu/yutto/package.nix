{
  lib,
  python3Packages,
  fetchFromGitHub,
  ffmpeg,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "yutto";
  version = "2.1.1";
  pyproject = true;

  pythonRelaxDeps = true;

  src = fetchFromGitHub {
    owner = "yutto-dev";
    repo = "yutto";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zolH3mf9YQLZLK98hhbHqUdDLRDodS/fChyfZ/xzVew=";
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

  postPatch = ''
    sed -ie 's/requires = \["uv_build[^"]*"]/requires = ["uv_build"]/' pyproject.toml
  '';

  pythonImportsCheck = [ "yutto" ];

  meta = {
    description = "Bilibili downloader";
    homepage = "https://github.com/yutto-dev/yutto";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ linsui ];
    mainProgram = "yutto";
  };
})
