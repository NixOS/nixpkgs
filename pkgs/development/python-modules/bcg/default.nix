{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  setuptools,
  appdirs,
  click,
  click-log,
  looseversion,
  paho-mqtt,
  pyaml,
  pyserial,
  schema,
  simplejson,
}:
buildPythonPackage (finalAttrs: {
  pname = "bcg";
  version = "1.17.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "hardwario";
    repo = "bch-gateway";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2Yh5MeIv+BIxjoO9GOPqq7xTAFhyBvnxPy7DeO2FrkI=";
  };

  patches = [
    (fetchpatch {
      # https://github.com/hardwario/bch-gateway/pull/19
      name = "bcg-fix-import-with-Python-3.12.patch";
      url = "https://github.com/hardwario/bch-gateway/pull/19/commits/1314c892992d8914802b6c42602c39f6a1418fca.patch";
      hash = "sha256-dNiBppXjPSMUe2yiiSc9gGbAc8l4mI41wWq+g7PkD/Y=";
    })
  ];
  postPatch = ''
    sed -ri 's/@@VERSION@@/${finalAttrs.version}/g' \
      bcg/__init__.py setup.py
  '';

  build-system = [ setuptools ];

  dependencies = [
    appdirs
    click
    click-log
    looseversion
    paho-mqtt
    pyaml
    pyserial
    schema
    simplejson
  ];

  pythonImportsCheck = [ "bcg" ];

  meta = {
    homepage = "https://github.com/hardwario/bch-gateway";
    description = "HARDWARIO Gateway (Python Application «bcg»)";
    mainProgram = "bcg";
    platforms = lib.platforms.linux;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ cynerd ];
  };
})
