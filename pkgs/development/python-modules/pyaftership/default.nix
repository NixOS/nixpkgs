{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  aiohttp,
  aresponses,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyaftership";
  version = "23.1.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ludeeus";
    repo = "pyaftership";
    tag = finalAttrs.version;
    hash = "sha256-njlDScmxIYWxB4EL9lOSGCXqZDzP999gI9EkpcZyFlE=";
  };

  propagatedBuildInputs = [ aiohttp ];

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytestCheckHook
  ];

  postPatch = ''
    # Upstream is releasing with the help of a CI to PyPI, GitHub releases
    # are not in their focus
    substituteInPlace setup.py \
      --replace 'version="main",' 'version="${finalAttrs.version}",'
  '';

  pythonImportsCheck = [ "pyaftership" ];

  meta = {
    description = "Python wrapper package for the AfterShip API";
    homepage = "https://github.com/ludeeus/pyaftership";
    changelog = "https://github.com/ludeeus/pyaftership/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jamiemagee ];
  };
})
