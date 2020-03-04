{ stdenv
, buildPythonPackage
, fetchPypi
, enchant2
}:

buildPythonPackage rec {
  pname = "pyenchant";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fc31cda72ace001da8fe5d42f11c26e514a91fa8c70468739216ddd8de64e2a0";
  };

  propagatedBuildInputs = [ enchant2 ];

  postPatch = let
    libext = stdenv.hostPlatform.extensions.sharedLibrary;
  in ''
    # Use the $PYENCHANT_LIBRARY_PATH envvar lookup line to hard-code the
    # location of the nix enchant-2 library into _enchant.py.
    #
    # Also, they hardcode a bad path for Darwin in their library search code;
    # This code should never be hit, but in case it does, we don't want to have
    # it "accidentally" work by pulling something from /opt.
    substituteInPlace enchant/_enchant.py                  \
      --replace 'os.environ.get("PYENCHANT_LIBRARY_PATH")' \
                "'${enchant2}/lib/libenchant-2${libext}'"  \
      --replace '/opt/local/lib/' ""
  '';

  # dictionaries needed for tests
  doCheck = false;

  meta = with stdenv.lib; {
    description = "pyenchant: Python bindings for the Enchant spellchecker";
    homepage = https://github.com/pyenchant/pyenchant;
    license = licenses.lgpl21;
  };

}
