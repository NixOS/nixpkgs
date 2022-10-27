{ lib, stdenv
, buildPythonPackage
, isPy27
, fetchPypi
, enchant2
}:

buildPythonPackage rec {
  pname = "pyenchant";
  version = "3.2.2";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1cf830c6614362a78aab78d50eaf7c6c93831369c52e1bb64ffae1df0341e637";
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

  meta = with lib; {
    description = "pyenchant: Python bindings for the Enchant spellchecker";
    homepage = "https://github.com/pyenchant/pyenchant";
    license = licenses.lgpl21;
  };

}
