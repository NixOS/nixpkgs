{
  lib,
  buildPythonPackage,
  fetchPypi,
  requests,
  audioread,
  pkgs,
}:

buildPythonPackage rec {
  pname = "pyacoustid";
  version = "1.3.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-X09IcZHBnruQgnCxt7UpfxMtozKxVouWqRRXTAee0Xc=";
  };

  propagatedBuildInputs = [
    requests
    audioread
  ];

  postPatch = ''
    sed -i \
        -e '/^FPCALC_COMMAND *=/s|=.*|= "${pkgs.chromaprint}/bin/fpcalc"|' \
        acoustid.py
  '';

  # package has no tests
  doCheck = false;

  pythonImportsCheck = [ "acoustid" ];

  meta = with lib; {
    description = "Bindings for Chromaprint acoustic fingerprinting";
    homepage = "https://github.com/sampsyo/pyacoustid";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
