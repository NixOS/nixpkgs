{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "bunch";
  version = "unstable-2017-11-21";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  # Use a fork as upstream is dead
  src = fetchFromGitHub {
    owner = "olivecoder";
    repo = pname;
    rev = "71ac9d5c712becd4c502ab3099203731a0f1122e";
    hash = "sha256-XOgzJkcIqkAJFsKAyt2jSEIxcc0h2gFC15xy5kAs+7s=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "rU" "r"
  '';

  # No real tests available
  doCheck = false;

  pythonImportsCheck = [ "bunch" ];

  meta = with lib; {
    description = "Python dictionary that provides attribute-style access";
    homepage = "https://github.com/dsc/bunch";
    license = licenses.mit;
    maintainers = [ ];
  };
}
