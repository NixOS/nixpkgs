{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyhomeworks";
  version = "1.1.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Jq+rjhjmnPFNaEuCHyi+8i20RgLf1rpZg6QqwE7ax7M=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools~=69.2.0" "setuptools" \
      --replace-fail ', "wheel~=0.43.0"' ""
  '';

  build-system = [ setuptools ];

  # Project has no real tests
  doCheck = false;

  pythonImportsCheck = [ "pyhomeworks" ];

  meta = {
    description = "Python interface to Lutron Homeworks Series 4/8";
    homepage = "https://github.com/dubnom/pyhomeworks";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
