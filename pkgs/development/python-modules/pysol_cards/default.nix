{ stdenv, fetchPypi, python }:

python.pkgs.buildPythonPackage rec {
  pname   = "pysol_cards";
  version = "0.8.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0w0waj7r1kqlpic6g3pyg4208i393gc0zxb6n6k0vqhm6nivdcs5";
  };

  propagatedBuildInputs = with python.pkgs; [ pbr random2 six ];

  ## Need to fix test deps, relies on stestr and a few other packages that aren't available on nixpkgs
  #checkInputs = with python.pkgs; [ pbr testtools stestr ];
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "https://github.com/shlomif/pysol_cards";
    description = "Allow the python developer to generate the initial deals of some PySol FC games";
    license = licenses.mit; # expat version
    maintainers = with maintainers; [ genesis ];
  };

}
