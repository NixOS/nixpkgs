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
  version = "0.5.5";

  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-P9yvdvYKG5SP+ON9w5jQPPnOdCcGXVgwgrktp6T/WmM=";
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

  meta = {
    description = "API for the GNU Privacy Guard (GnuPG)";
    homepage = "https://github.com/vsajip/python-gnupg";
    changelog = "https://github.com/vsajip/python-gnupg/releases/tag/${version}";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
