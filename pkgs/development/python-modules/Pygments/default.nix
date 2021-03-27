{ lib
, buildPythonPackage
, fetchPypi
, docutils
, pytestCheckHook
, doCheck ? true
}:

buildPythonPackage rec {
  pname = "Pygments";
  version = "2.7.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "df49d09b498e83c1a73128295860250b0b7edd4c723a32e9bc0d295c7c2ec337";
  };

  propagatedBuildInputs = [ docutils ];

  inherit doCheck;
  checkInputs = [ pytestCheckHook ];

  meta = {
    homepage = "https://pygments.org/";
    description = "A generic syntax highlighter";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ ];
  };
}
