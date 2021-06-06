{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, isPy3k
, setuptoolsDarcs
, darcsver
, pkgs
}:

buildPythonPackage rec {
  pname = "pycryptopp";
  version = "0.7.1.869544967005693312591928092448767568728501330214";
  disabled = isPy3k;  # see https://bitbucket.org/pypy/pypy/issue/1190/

  src = fetchPypi {
    inherit pname version;
    sha256 = "17v98bhh3nd6rkw0kk1xmnc9vm5ql0fji4in2wyd4zlvlfhmgb88";
  };

  patches = [
    (fetchpatch {
      name = "pycryptopp-cryptopp_6.patch";
      url = "https://aur.archlinux.org/cgit/aur.git/plain/api_change.patch?h=pycryptopp&id=55f2973d6ca5e9e70438f2eadb7fb575b1a5048d";
      sha256 = "0lvl2d32d2vkb0v6d39p9whda5bdrmlsjd41zy0x0znqm53a9i99";
      stripLen = 1;
      extraPrefix = "src/";
    })
  ];

  # Prefer crypto++ library from the Nix store over the one that's included
  # in the pycryptopp distribution.
  preConfigure = "export PYCRYPTOPP_DISABLE_EMBEDDED_CRYPTOPP=1";

  buildInputs = [ setuptoolsDarcs darcsver pkgs.cryptopp ];

  meta = with lib; {
    homepage = "https://tahoe-lafs.org/trac/pycryptopp";
    description = "Python wrappers for the Crypto++ library";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };

}
