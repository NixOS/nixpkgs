{ lib
, buildPythonPackage
, fetchPypi
, requests
, audioread
, pkgs
}:

buildPythonPackage rec {
  pname = "pyacoustid";
  version = "1.2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c279d9c30a7f481f1420fc37db65833b5f9816cd364dc2acaa93a11c482d4141";
  };

  propagatedBuildInputs = [ requests audioread ];

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
