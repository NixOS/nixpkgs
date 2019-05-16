{ stdenv
, buildPythonPackage
, fetchPypi
, requests
, audioread
, pkgs
}:

buildPythonPackage rec {
  pname = "pyacoustid";
  version = "1.1.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "efb6337a470c9301a108a539af7b775678ff67aa63944e9e04ce4216676cc777";
  };

  propagatedBuildInputs = [ requests audioread ];

  postPatch = ''
    sed -i \
        -e '/^FPCALC_COMMAND *=/s|=.*|= "${pkgs.chromaprint}/bin/fpcalc"|' \
        acoustid.py
  '';

  meta = with stdenv.lib; {
    description = "Bindings for Chromaprint acoustic fingerprinting";
    homepage = "https://github.com/sampsyo/pyacoustid";
    license = licenses.mit;
  };

}
