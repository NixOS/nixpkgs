{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build system
  hatchling,
  hatch-vcs,

  # dependencies
  ghome-foyer-api,
  gpsoauth,
  grpcio,
  requests,
  simplejson,
  zeroconf,

  # test dependencies
  pytestCheckHook,
  faker,
}:

buildPythonPackage rec {
  pname = "glocaltokens";
  version = "0.7.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "leikoilja";
    repo = "glocaltokens";
    tag = "v${version}";
    hash = "sha256-+7HpyZUumu1r/UXM4awckjTkpVbCz7MsAJOp2JiJzho=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    ghome-foyer-api
    gpsoauth
    grpcio
    requests
    simplejson
    zeroconf
  ];

  nativeCheckInputs = [
    pytestCheckHook
    faker
  ];

  pythonImportsCheck = [
    "glocaltokens"
    "glocaltokens.client"
    "glocaltokens.scanner"
  ];

  meta = {
    description = "Library to extract google home devices local authentication tokens from google servers";
    homepage = "https://github.com/leikoilja/glocaltokens";
    changelog = "https://github.com/leikoilja/glocaltokens/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      hensoko
    ];
  };
}
