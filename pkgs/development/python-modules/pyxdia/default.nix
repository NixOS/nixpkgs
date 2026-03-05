{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  fetchzip,
  pythonOlder,
  setuptools,
  blink,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyxdia";
  version = "0.1.0";

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "mborgerson";
    repo = "xdia";
    tag = "v${version}";
    hash = "sha256-VfA4xaszdd8ZhPdbEsawDzzl2F4tM4vk8uQIuDpULE0=";
  };

  xdia = fetchzip {
    url = "https://github.com/mborgerson/xdia/releases/download/v${version}/xdia.zip";
    stripRoot = false;
    hash = "sha256-/r60NLacyL92drPpligmom5Eb3wNfzTJ0M0cieu7Ouw=";
  };

  xdialdr = fetchzip {
    url = "https://github.com/mborgerson/xdia/releases/download/v${version}/xdialdr.tar.xz";
    stripRoot = false;
    hash = "sha256-rt2CF/p1jjWME9OPNyi+qmXPFmWxz4IS434n+Hb/8B4=";
  };

  pyproject = true;
  sourceRoot = "${src.name}/pyxdia";

  postPatch = ''
    mkdir pyxdia/bin
    cp $xdia/* pyxdia/bin
    cp $xdialdr/* pyxdia/bin
  ''
  + lib.optionalString (with stdenv.hostPlatform; !isLinux || !isx86_64) ''
    ln -s ${lib.getExe blink} pyxdia/bin
  ''
  + ''
    rm pyxdia/bin/*.txt
  '';

  build-system = [ setuptools ];

  PDB_TEST_FILES = "${src}/tests";

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pyxdia" ];

  meta = {
    description = "Extract useful program information from PDB files";
    homepage = "https://github.com/mborgerson/xdia";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ misaka18931 ];
  };
}
