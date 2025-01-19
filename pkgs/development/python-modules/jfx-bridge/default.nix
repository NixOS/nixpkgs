{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
}:

buildPythonPackage rec {
  pname = "jfx-bridge";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "justfoxing";
    repo = "jfx_bridge";
    rev = version;
    hash = "sha256-fpUrKNGqTpthhTfohCbwO1GBDAP/YnLWeapVhZftldg=";
  };

  patches = [ ./no-invoke-git.patch ];
  postPatch = ''
    substituteInPlace ./setup.py --subst-var-by version ${version}
  '';

  build-system = [
    setuptools
    wheel
  ];

  pythonImportsCheck = [ "jfx_bridge" ];

  meta = {
    description = "Base Python2/3 RPC bridge used for ghidra_bridge";
    homepage = "https://github.com/justfoxing/jfx_bridge";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ scoder12 ];
  };
}
