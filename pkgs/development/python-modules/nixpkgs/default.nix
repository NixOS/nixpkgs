{ stdenv
, buildPythonPackage
, fetchpatch
, fetchPypi
, pbr
, pythonix
, pythonAtLeast
}:

buildPythonPackage rec {
  pname = "nixpkgs";
  version = "0.2.3";
  disabled = ! pythonAtLeast "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "12ycbv31g4qv14aq6hfb85hhx026lgvzqfsrkpzb64na0c1yjcvn";
  };

  buildInputs = [ pbr ];
  propagatedBuildInputs = [ pythonix ];

  meta = with stdenv.lib; {
    description = "Allows to `from nixpkgs import` stuff in interactive Python sessions";
    homepage = https://github.com/t184256/nixpkgs-python-importer;
    license = licenses.mit;
    maintainers = with maintainers; [ t184256 ];
  };

}
