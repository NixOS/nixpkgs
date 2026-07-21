{
  lib,
  buildPythonPackage,
  fetchurl,
  pythonOlder,
  uv-build,
}:

buildPythonPackage rec {
  pname = "agent-budget";
  version = "0.1.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchurl {
    url = "https://github.com/MukundaKatta/agent-budget/releases/download/v${version}/agent_budget-${version}.tar.gz";
    hash = "sha256-xql6X9NdcbwG8771ql8xOyeZFKn0UN0E3uOQQrNp54w=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.11.7,<0.12.0" uv_build
  '';

  build-system = [ uv-build ];

  # Pure stdlib at runtime — no `dependencies` list needed.

  pythonImportsCheck = [ "agent_budget" ];

  doCheck = false;

  meta = {
    description = "Production retry/budget primitive for LLM and agent calls with adversarial-loop detection";
    longDescription = ''
      The retry/budget primitive ``tenacity`` isn't, with the three things
      that matter for production LLM-shaped work: cost cap, structured
      per-attempt events, and adversarial-loop detection.

      Wraps any callable with cost cap, attempts cap, wall-clock cap,
      exponential backoff (clamped to remaining wall-clock), exception
      classification (retry_on / fatal_on / unknown), structured AttemptEvent
      lifecycle hooks, and adversarial-loop detection via error
      fingerprinting that catches the retry-amplification class of bug from
      Instructor #2056. Zero runtime dependencies.
    '';
    homepage = "https://github.com/MukundaKatta/agent-budget";
    changelog = "https://github.com/MukundaKatta/agent-budget/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mukundakatta ];
  };
}
