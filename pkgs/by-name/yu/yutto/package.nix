{ lib
, python3Packages
, fetchFromGitHub
, ffmpeg
, nix-update-script
}:

python3Packages.buildPythonApplication {
  pname = "yutto";
  version = "2.0.0b36-unstable-2024-03-04";
  format = "pyproject";

  disabled = python3Packages.pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "yutto-dev";
    repo = "yutto";
    rev = "f2d34f9e2a2d45ed8ed6ae4c2bf91af248da27f0";
    hash = "sha256-/zTQt+/sCjnQPt8YyKvRXpWVpN/yi2LrhpFH4FPbeOc=";
  };

  nativeBuildInputs = with python3Packages; [
    poetry-core
  ];

  propagatedBuildInputs = with python3Packages; [
    httpx
    aiofiles
    biliass
    dict2xml
    colorama
    typing-extensions
  ] ++ (with httpx.optional-dependencies; http2 ++ socks);

  preFixup = ''
    makeWrapperArgs+=(--prefix PATH : ${lib.makeBinPath [ ffmpeg ]})
  '';

  pythonImportsCheck = [ "yutto" ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "A Bilibili downloader";
    homepage = "https://github.com/yutto-dev/yutto";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ linsui ];
    mainProgram = "yutto";
  };
}
