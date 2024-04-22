{ lib
, python3Packages
, fetchFromGitHub
, ffmpeg
, nix-update-script
}:

python3Packages.buildPythonApplication rec {
  pname = "yutto";
  version = "2.0.0-beta.37";
  format = "pyproject";

  disabled = python3Packages.pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "yutto-dev";
    repo = "yutto";
    rev = "v${version}";
    hash = "sha256-daRuFYfR3FjvhVsQM1FXI19iOH+bukh6WxfH5O+CFk4=";
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

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version" "unstable" ];
  };

  meta = with lib; {
    description = "A Bilibili downloader";
    homepage = "https://github.com/yutto-dev/yutto";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ linsui ];
    mainProgram = "yutto";
  };
}
