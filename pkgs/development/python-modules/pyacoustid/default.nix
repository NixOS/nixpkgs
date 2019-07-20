{ stdenv
, buildPythonPackage
, fetchPypi
, requests
, audioread
, pkgs
}:

buildPythonPackage rec {
  pname = "pyacoustid";
  version = "1.1.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "07394a8ae84625a0a6fef2d891d19687ff59cd955caaf48097da2826043356fd";
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
