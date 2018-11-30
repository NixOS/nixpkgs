{ stdenv
, buildPythonPackage
, fetchPypi
, pkgs
}:

buildPythonPackage rec {
  pname = "pyenchant";
  version = "1.6.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "25c9d2667d512f8fc4410465fdd2e868377ca07eb3d56e2b6e534a86281d64d3";
  };

  propagatedBuildInputs = [ pkgs.enchant ];

  patchPhase = let
    path_hack_script = "s|LoadLibrary(e_path)|LoadLibrary('${pkgs.enchant}/lib/' + e_path)|";
  in ''
    sed -i "${path_hack_script}" enchant/_enchant.py

    # They hardcode a bad path for Darwin in their library search code
    substituteInPlace enchant/_enchant.py --replace '/opt/local/lib/' ""
  '';

  # dictionaries needed for tests
  doCheck = false;

  meta = with stdenv.lib; {
    description = "pyenchant: Python bindings for the Enchant spellchecker";
    homepage = https://pythonhosted.org/pyenchant/;
    license = licenses.lgpl21;
  };

}
