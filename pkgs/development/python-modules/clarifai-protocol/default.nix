{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  python,
  pypaInstallHook,
  wheelUnpackHook,
  grpcio,
}:

let
  pythonVersionNoDot = builtins.replaceStrings [ "." ] [ "" ] python.pythonVersion;
  systemToPlatform = {
    "aarch64-linux" = "manylinux_2_17_aarch64.manylinux2014_aarch64";
    "x86_64-linux" = "manylinux_2_17_x86_64.manylinux2014_x86_64";
    "aarch64-darwin" = "macosx_11_0_universal2";
    "x86_64-darwin" = "macosx_11_0_universal2";
  };

  hashes = {
    "39-x86_64-linux" = "sha256-uGbsxSHGfYVzRiy1YEkQMkJi2yPLdSj3fe3adp1WjP0=";
    "310-x86_64-linux" = "sha256-1SO/1lpB3aRWisxFlt8K5lwFEOiDXjC4iQRai77L+8E=";
    "311-x86_64-linux" = "sha256-99VdM1fAcuiblReWL5I8+H0psCKR00HYZr/wRGT7nd8=";
    "312-x86_64-linux" = "sha256-bbggF4rGDrXOpSegreFHgK0H/z7xaR9hb7z6SYp7nlU=";
    "313-x86_64-linux" = "sha256-M9/t7JgIjh7yiZeEq9K2tGQ4oLneVhXf0rUfL8p09Tg=";
    "39-aarch64-linux" = "sha256-wuEncCbqWdqO72zovzHrmb34on73eaQgFBmQZdUnwkE=";
    "310-aarch64-linux" = "sha256-uLHEEPcVakctNT428pNlaq0yKDpvMLynDP2lDobiebA=";
    "311-aarch64-linux" = "sha256-d2A4mKP4Dlnm6J31wPyAHg8d5MjFF4wcREe5FVFeayU=";
    "312-aarch64-linux" = "sha256-aW295fQogAjaVK6saHhduKsVsncIv4BsfRW6qHlyb3g=";
    "313-aarch64-linux" = "sha256-mloW8TGkBJWXqO6xOqHhra3ZXuGQWf6dEGSrkdD0sb0=";
    "39-darwin" = "sha256-uU9RGo5glYOPp8nEYqj4c1TB3Xa1KwrNWMqNDpJsSjY=";
    "310-darwin" = "sha256-80U0geHKJLVhhmvHayXWHWaV9ifJjWtR9mbwCUDfPu0=";
    "311-darwin" = "sha256-kM2YVzPa22QgIRV4zP4kcvTE8al/RW0Oo6lyxJl3JxU=";
    "312-darwin" = "sha256-t4qbP5wqE8cgkvN+vG6zOeS+s5+U/GjmbeeHytIo9/o=";
    "313-darwin" = "sha256-ds2kj87miODVUE8Lrjuzz8L+2HxaQ7jTxGQF0/Odrpg=";
  };
in
buildPythonPackage rec {
  pname = "clarifai-protocol";
  version = "0.0.14";
  pyproject = false;

  src = fetchPypi {
    pname = "clarifai_protocol";
    inherit version;
    format = "wheel";
    python = "cp${pythonVersionNoDot}";
    abi = "cp${pythonVersionNoDot}";
    dist = "cp${pythonVersionNoDot}";
    platform = systemToPlatform.${stdenv.hostPlatform.system} or (throw "unsupported system");
    hash =
      if stdenv.hostPlatform.isDarwin then
        hashes."${pythonVersionNoDot}-darwin" or (throw "unsupported system/python version combination")
      else
        hashes."${pythonVersionNoDot}-${stdenv.hostPlatform.system}"
          or (throw "unsupported system/python version combination");
  };

  nativeBuildInputs = [
    pypaInstallHook
    wheelUnpackHook
  ];

  dependencies = [ grpcio ];

  # require clarifai and it causes a circular import
  dontUsePythonImportsCheck = true;

  # no tests
  doCheck = false;

  meta = {
    description = "Clarifai Python Runner Protocol";
    homepage = "https://pypi.org/project/clarifai-protocol";
    license = lib.licenses.asl20;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    maintainers = with lib.maintainers; [ natsukium ];
  };
}
