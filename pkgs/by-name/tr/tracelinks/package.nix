{
  fetchFromGitHub,
  help2man,
  lib,
  nix-update-script,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tracelinks";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "flox";
    repo = "tracelinks";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GftF2s2eRrkfzw2NpzTZ6Uhehcg2tMSOcsjHJssQJzU=";
  };

  makeFlags = [
    "PREFIX=$(out)"
    "VERSION=${finalAttrs.version}"
  ];
  nativeBuildInputs = [ help2man ];
  doCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Report on symbolic links encountered in path traversals";
    homepage = "https://github.com/flox/tracelinks";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ limeytexan ];
    platforms = lib.platforms.unix;
  };
})
