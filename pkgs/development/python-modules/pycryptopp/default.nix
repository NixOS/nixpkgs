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
  version = "0.6.0.1206569328141510525648634803928199668821045408958";
  disabled = isPy3k || isPyPy;  # see https://bitbucket.org/pypy/pypy/issue/1190/

  src = fetchPypi {
    inherit pname version;
    sha256 = "0n90h1yg7bfvlbhnc54xb6dbqm286ykaksyg04kxlhyjgf8mhq8i";
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
