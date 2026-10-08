{
  lib,
  python3Packages,
  fetchFromGitHub,
  rustPlatform,
  ffmpeg,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "yutto";
  version = "2.3.0";
  pyproject = true;

  pythonRelaxDeps = true;

  src = fetchFromGitHub {
    owner = "yutto-dev";
    repo = "yutto";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1k4VqnOKozlPrSebVp0vdaJI/Ra+v7akV6zLZMYMJ88=";
  };

  cargoRoot = "rust";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs)
      pname
      version
      src
      cargoRoot
      ;
    hash = "sha256-9KJlEaOLKVNTz+OsiX3p7Bbv1wFzoi6UaLKksrXMbdw=";
  };

  build-system = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

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
      segno
      websockets
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
