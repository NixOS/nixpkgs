{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "usbrip";
  version = "0-unstable-2021-07-02";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "snovvcrash";
    repo = "usbrip";
    rev = "0f3701607ba13212ebefb4bbd9e68ec0e22d76ac";
    hash = "sha256-/gIqae3BCzw29y3JVZSC0AntZ4Zg10U3vl+fDZdHmu8=";
  };

  postPatch = ''
    # Remove install helpers which we don't need
    substituteInPlace setup.py \
      --replace-fail "resolve('wheel')" "" \
      --replace-fail "'install': LocalInstallCommand," ""
  '';

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    termcolor
    terminaltables
    tqdm
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "usbrip" ];

  meta = {
    description = "Tool to track the history of USB events";
    homepage = "https://github.com/snovvcrash/usbrip";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "usbrip";
    platforms = lib.platforms.linux;
  };
})
