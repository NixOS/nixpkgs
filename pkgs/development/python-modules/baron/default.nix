{
  lib,
  fetchPypi,
  buildPythonPackage,
  rply,
  pytestCheckHook,
  isPy3k,
}:

buildPythonPackage rec {
  pname = "baron";
  version = "0.10.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-r4Iq1E1OtCXIUW30I5rE/bqf2zmO935JJM18m0BFvC8=";
  };

  propagatedBuildInputs = [ rply ];

  nativeCheckInputs = [ pytestCheckHook ];

  doCheck = isPy3k;

  meta = with lib; {
    homepage = "https://github.com/gristlabs/asttokens";
    description = "Abstraction on top of baron, a FST for python to make writing refactoring code a realistic task";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ marius851000 ];
  };
}
