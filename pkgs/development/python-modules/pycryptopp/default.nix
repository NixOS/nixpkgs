{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
, isPyPy
, setuptoolsDarcs
, darcsver
, pkgs
}:

buildPythonPackage rec {
  pname = "pycryptopp";
  version = "0.7.1.869544967005693312591928092448767568728501330214";
  disabled = isPy3k || isPyPy;  # see https://bitbucket.org/pypy/pypy/issue/1190/

  src = fetchPypi {
    inherit pname version;
    sha256 = "08ad57a1a39b7ed23c173692281da0b8d49d98ad3dcc09f8cca6d901e142699f";
  };

  # Prefer crypto++ library from the Nix store over the one that's included
  # in the pycryptopp distribution.
  preConfigure = "export PYCRYPTOPP_DISABLE_EMBEDDED_CRYPTOPP=1";

  buildInputs = [ setuptoolsDarcs darcsver pkgs.cryptopp ];

  meta = with stdenv.lib; {
    homepage = http://allmydata.org/trac/pycryptopp;
    description = "Python wrappers for the Crypto++ library";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };

}
