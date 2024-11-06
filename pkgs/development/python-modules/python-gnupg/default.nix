{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  gnupg,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "python-gnupg";
  version = "0.5.3";

  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-KQ2N25zWPfls/pKEubJl8Z/W4UXlWC3Fj9cnHwJtCkc=";
  };

  postPatch = ''
    substituteInPlace gnupg.py \
      --replace "gpgbinary='gpg'" "gpgbinary='${gnupg}/bin/gpg'"
    substituteInPlace test_gnupg.py \
      --replace "os.environ.get('GPGBINARY', 'gpg')" "os.environ.get('GPGBINARY', '${gnupg}/bin/gpg')"
  '';

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # network access
    "test_search_keys"
  ];

  pythonImportsCheck = [ "gnupg" ];

  meta = with lib; {
    description = "API for the GNU Privacy Guard (GnuPG)";
    homepage = "https://github.com/vsajip/python-gnupg";
    changelog = "https://github.com/vsajip/python-gnupg/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ copumpkin ];
  };
}
