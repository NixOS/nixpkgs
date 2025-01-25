{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  jfx-bridge,
  setuptools,
  wheel,
}:

buildPythonPackage rec {
  pname = "ghidra-bridge";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "justfoxing";
    repo = "ghidra_bridge";
    tag = version;
    hash = "sha256-VcAl1tamsuHvZRtBP0+DCl2A9d7E6aoj2AbJhEcBNMM=";
  };

  patches = [ ./no-invoke-git.patch ];
  postPatch = ''
    substituteInPlace ./setup.py --subst-var-by version ${version}
  '';

  build-system = [ setuptools ];

  dependencies = [ jfx-bridge ];

  pythonImportsCheck = [ "ghidra_bridge" ];

  meta = {
    description = "Python 3 bridge to Ghidra's Python scripting";
    homepage = "https://github.com/justfoxing/ghidra_bridge";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ scoder12 ];
  };
}
