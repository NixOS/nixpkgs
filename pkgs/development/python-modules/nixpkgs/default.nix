{ stdenv
, buildPythonPackage
, fetchPypi
, pbr
, pythonix
, pythonAtLeast
}:

buildPythonPackage rec {
  pname = "nixpkgs";
  version = "0.2.2";
  disabled = ! pythonAtLeast "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0gsrd99kkv99jsrh3hckz7ns1zwndi9vvh4465v4gnpz723dd6fj";
  };

  buildInputs = [ pbr ];
  propagatedBuildInputs = [ pythonix ];

  meta = with stdenv.lib; {
    description = "Allows to `from nixpkgs import` stuff in interactive Python sessions";
    homepage = http://github.com/t184256/nixpkgs-python-importer;
    license = licenses.mit;
    maintainers = with maintainers; [ t184256 ];
  };

}
