{
  stdenvNoCC,
  fetchFromGitHub,
  jupyter-collaboration,
  pytest-jupyter,
  pytestCheckHook,
  websockets,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "jupyter-collaboration-test";
  inherit (jupyter-collaboration) version;

  src = fetchFromGitHub {
    owner = "jupyterlab";
    repo = "jupyter-collaboration";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-6hDYB1uC0WraB37s9EKLJF7jyFu0B3xLocuLYyKj4hs=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "timeout = 300" ""
  '';

  installPhase = ''
    touch $out
  '';

  env.HOME = "$TMPDIR";

  doCheck = true;

  nativeCheckInputs = [
    jupyter-collaboration
    pytest-jupyter
    pytestCheckHook
    websockets
  ];
})
