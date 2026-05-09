{
  yubal,
  python312Packages,
}:

with python312Packages;
buildPythonPackage {
  pname = yubal.pname + "-cli";
  inherit (yubal) version src;
  sourceRoot = "source/packages/yubal";
  pyproject = true;

  build-system = [
    uv-build
  ];

  pythonImportsCheck = [ "yubal" ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.9.23,<0.10.0" "uv-build"
  '';

  dependencies = [
    ytmusicapi
    pydantic
    yt-dlp
    pathvalidate
    rapidfuzz
    mediafile
    httpx
    unidecode
    numpy_1
  ];
}
