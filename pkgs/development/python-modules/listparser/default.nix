{
  fetchFromGitHub,
  lib,
  lxml,
  nix-update-script,
  poetry-core,
  pypaBuildHook,
  pypaInstallHook,
  pytestCheckHook,
  requests,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "listparser";
  version = "0.20";

  src = fetchFromGitHub {
    owner = "kurtmckee";
    repo = "listparser";
    rev = "v${finalAttrs.version}";
    hash = "sha256-eg9TrjDgvHsYt/0JQ7MK/uGc3KK3uGr3jRxzG0FlySg=";
  };

  nativeBuildInputs = [
    poetry-core
    pypaBuildHook
    pypaInstallHook
  ];

  propagatedBuildInputs = [
    requests
    lxml
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "listparser"
  ];

  doCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Parse OPML subscription lists in Python";
    homepage = "https://github.com/kurtmckee/listparser";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.colinsane ];
    platforms = platforms.linux;
  };
})
