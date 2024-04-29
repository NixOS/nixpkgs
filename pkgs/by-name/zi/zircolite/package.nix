{ lib
, fetchFromGitHub
, makeWrapper
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "zircolite";
  version = "2.20.0";
  format = "other";

  src = fetchFromGitHub {
    owner = "wagga40";
    repo = "Zircolite";
    rev = "refs/tags/${version}";
    hash = "sha256-a7xwF0amsh2SycOjtZpk3dylcBGG9uYd7vmbnz/f9Ug=";
  };

  __darwinAllowLocalNetworking = true;

  build-system = [
    makeWrapper
  ];

  dependencies = with python3.pkgs; [
    aiohttp
    colorama
    elastic-transport
    elasticsearch
    evtx
    jinja2
    lxml
    orjson
    requests
    tqdm
    urllib3
    xxhash
  ] ++ elasticsearch.optional-dependencies.async;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share $out/share/zircolite
    cp -R . $out/share/zircolite

    makeWrapper ${python3.interpreter} $out/bin/zircolite \
      --set PYTHONPATH "$PYTHONPATH:$out/bin/zircolite.py" \
      --add-flags "$out/share/zircolite/zircolite.py"

    runHook postInstall
  '';

  meta = with lib; {
    description = "SIGMA-based detection tool for EVTX, Auditd, Sysmon and other logs";
    mainProgram = "zircolite";
    homepage = "https://github.com/wagga40/Zircolite";
    changelog = "https://github.com/wagga40/Zircolite/releases/tag/${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
