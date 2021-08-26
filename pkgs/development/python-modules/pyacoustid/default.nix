{ lib
, buildPythonPackage
, fetchPypi
, requests
, audioread
, pkgs
}:

buildPythonPackage rec {
  pname = "pyacoustid";
  version = "1.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e62b2929fbc5ead508758d2f700f5d355f7d83d14f5efe33c1d4fc59cbdeba84";
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
