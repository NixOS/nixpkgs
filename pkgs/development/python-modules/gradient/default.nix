{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  hatch-fancy-pypi-readme,
  httpx,
  pydantic,
  typing-extensions,
  anyio,
  distro,
  sniffio,
}:

buildPythonPackage (finalAttrs: {
  pname = "gradient";
  version = "3.10.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "digitalocean";
    repo = "gradient-python";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Psre4HdF4/cgQ5CcM3H6PC+6asej4Is4+932Gvym774=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "hatchling==1.26.3" "hatchling"
  '';

  nativeBuildInputs = [
    hatchling
    hatch-fancy-pypi-readme
  ];

  dependencies = [
    httpx
    pydantic
    typing-extensions
    anyio
    distro
    sniffio
  ];

  pythonImportsCheck = [ "gradient" ];

  meta = {
    description = "Python API library for Gradient";
    mainProgram = "gradient";
    homepage = "https://github.com/digitalocean/gradient-python";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ thoughtpolice ];
  };
})
