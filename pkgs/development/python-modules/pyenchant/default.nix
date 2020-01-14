{ stdenv
, buildPythonPackage
, fetchPypi
, pkgs
}:

buildPythonPackage rec {
  pname = "pyenchant";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fc31cda72ace001da8fe5d42f11c26e514a91fa8c70468739216ddd8de64e2a0";
  };

  propagatedBuildInputs = [ pkgs.enchant1 ];

  patchPhase = let
    path_hack_script = "s|LoadLibrary(e_path)|LoadLibrary('${pkgs.enchant1}/lib/' + e_path)|";
  in ''
    sed -i "${path_hack_script}" enchant/_enchant.py

    # They hardcode a bad path for Darwin in their library search code
    substituteInPlace enchant/_enchant.py --replace '/opt/local/lib/' ""
  '';

  # dictionaries needed for tests
  doCheck = false;

  meta = with stdenv.lib; {
    description = "pyenchant: Python bindings for the Enchant spellchecker";
    homepage = https://github.com/pyenchant/pyenchant;
    license = licenses.lgpl21;
    badPlatforms = [ "x86_64-darwin" ];
  };

}
