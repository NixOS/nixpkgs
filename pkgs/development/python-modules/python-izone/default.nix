{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  aiohttp,
  netifaces,
  pytest-aio,
  pytest-asyncio,
  pytestCheckHook,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "python-izone";
  version = "1.2.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Swamp-Ig";
    repo = "pizone";
    tag = "v${version}";
    hash = "sha256-0rj+tKn2pbFe+nczTMGLwIwmc4jCznGGF4/IMjlEvQg=";
  };

  patches = [
    # https://github.com/Swamp-Ig/pizone/pull/26
    (fetchpatch {
      name = "replace-async-timeout-with-asyncio.timeout.patch";
      url = "https://github.com/Swamp-Ig/pizone/commit/776a7c5682ecd1b75a0b36dea71c914c25476a77.patch";
      hash = "sha256-Cl71BErInSPtFNbPaV7E/LEDZPMuFNGKA8i5e+C3BMA=";
    })
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools_scm[toml] >= 4, <6" "setuptools-scm[toml]" \
      --replace-fail '"setuptools_scm_git_archive",' ""
  '';

  build-system = [ setuptools-scm ];

  dependencies = [
    aiohttp
    netifaces
  ];

  nativeCheckInputs = [
    pytest-aio
    pytest-asyncio
    pytestCheckHook
  ];

  doCheck = false; # most tests access network

  pythonImportsCheck = [ "pizone" ];

  meta = with lib; {
    description = "Python interface to the iZone airconditioner controller";
    homepage = "https://github.com/Swamp-Ig/pizone";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}
