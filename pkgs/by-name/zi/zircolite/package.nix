{
  lib,
  fetchFromGitHub,
  makeWrapper,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "zircolite";
  version = "4.7.1";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "wagga40";
    repo = "Zircolite";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BnWjlUJ+kL7KO3dsZ1gEUqhiv4ncbuf+nWiYzuFytrU=";
  };

  __darwinAllowLocalNetworking = true;

  build-system = [ makeWrapper ];

  dependencies =
    with python3.pkgs;
    [
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
    ]
    ++ elasticsearch.optional-dependencies.async;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share $out/share/zircolite
    cp -R . $out/share/zircolite

    makeWrapper ${python3.interpreter} $out/bin/zircolite \
      --set PYTHONPATH "$PYTHONPATH:$out/bin/zircolite.py" \
      --add-flags "$out/share/zircolite/zircolite.py"

    runHook postInstall
  '';

  meta = {
    description = "SIGMA-based detection tool for EVTX, Auditd, Sysmon and other logs";
    homepage = "https://github.com/wagga40/Zircolite";
    changelog = "https://github.com/wagga40/Zircolite/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "zircolite";
  };
})
