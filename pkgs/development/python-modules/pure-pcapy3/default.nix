{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pure-pcapy3";
  version = "1.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-uZ5F8W1K1BDrXrvH1dOeNT1+2n6G8K1S5NxcRaez6pI=";
  };

  # fixes: AttributeError: 'FixupTest' object has no attribute 'assertEquals'. Did you mean: 'assertEqual'?
  postPatch = ''
    substituteInPlace test/__init__.py \
      --replace-fail "assertEquals" "assertEqual"
  '';

  pythonImportsCheck = [ "pure_pcapy" ];

  meta = with lib; {
    description = "Reimplementation of pcapy";
    homepage = "https://github.com/rcloran/pure-pcapy-3";
    license = licenses.bsd2;
    maintainers = [ ];
  };
}
