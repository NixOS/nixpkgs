{
  lib,
  archinfo,
  arpy,
  buildPythonPackage,
  cart,
  cffi,
  fetchFromGitHub,
  minidump,
  pefile,
  pyelftools,
  pytestCheckHook,
  pyvex,
  pyxbe,
  pyxdia,
  setuptools,
  sortedcontainers,
  uefi-firmware,
  nix-update-script,
}:

let
  # The binaries are following the argr projects release cycle
  version = "10.0.3";

  # Binary files from https://github.com/angr/binaries (only used for testing and only here)
  binaries = fetchFromGitHub {
    owner = "angr";
    repo = "binaries";
    tag = "v${version}";
    hash = "sha256-dFzB8ioQh9RxIw1+J7NF1LQBRfyuzNvM0gD7Y+ifgUk=";
  };
in
buildPythonPackage (finalAttrs: {
  pname = "cle";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "angr";
    repo = "cle";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BCK7UfkLXczr61xWpHcgh5U/6TZ2gtxLnzkGTEZbL20=";
  };

  build-system = [ setuptools ];

  dependencies = [
    archinfo
    arpy
    cart
    cffi
    minidump
    pefile
    pyelftools
    pyvex
    pyxbe
    pyxdia
    sortedcontainers
    uefi-firmware
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  # Place test binaries in the right location (location is hard-coded in the tests)
  preCheck = ''
    export HOME=$TMPDIR
    cp -r ${binaries} $HOME/binaries
  '';

  # pythonRelaxDeps is resulting in a sed error
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"arpy==1.1.1"' '"arpy"'
  '';

  pythonImportsCheck = [ "cle" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Python loader for many binary formats";
    homepage = "https://github.com/angr/cle";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ fab ];
  };
})
