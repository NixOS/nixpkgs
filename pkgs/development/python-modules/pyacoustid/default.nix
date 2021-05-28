{ stdenv
, buildPythonPackage
, fetchPypi
, requests
, audioread
, pkgs
}:

buildPythonPackage rec {
  pname = "pyacoustid";
  version = "1.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0c3dsnfyldnsmyzczp5s5aqvbzcn360s0h4l3gm3k53lg57f762z";
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
