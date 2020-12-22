{ stdenv, buildPythonPackage, fetchpatch, fetchPypi, gnupg }:

buildPythonPackage rec {
  pname   = "python-gnupg";
  version = "0.4.6"; # Please remove the patch below when >0.4.6

  src = fetchPypi {
    inherit pname version;
    sha256 = "3aa0884b3bd414652c2385b9df39e7b87272c2eca1b8fcc3089bc9e58652019a";
  };

  patches = [
  ] ++ stdenv.lib.optionals (let cutoff = "0.4.6"; in version == cutoff || stdenv.lib.versionOlder version cutoff) [
    # Remove on next version bump
    (fetchpatch {
      url = "https://bitbucket.org/vinay.sajip/python-gnupg/commits/443fc58ed3ce5ea928d90c16d6cfac25e40c05ba/raw";
      sha256 = "1ppbg944227nj6yylhcxfr6bdrlhzripahmjh1a0c63vxzrcwg4m";
    })
  ];

  # Let's make the library default to our gpg binary
  postPatch = ''
    substituteInPlace gnupg.py \
    --replace "gpgbinary='gpg'" "gpgbinary='${gnupg}/bin/gpg'"
    substituteInPlace test_gnupg.py \
    --replace "gpgbinary=GPGBINARY" "gpgbinary='${gnupg}/bin/gpg'" \
    --replace "test_search_keys" "disabled__test_search_keys"
  '';

  meta = with stdenv.lib; {
    description = "A wrapper for the Gnu Privacy Guard";
    homepage    = "https://pypi.python.org/pypi/python-gnupg";
    license     = licenses.bsd3;
    maintainers = with maintainers; [ copumpkin ];
    platforms   = platforms.unix;
  };
}
