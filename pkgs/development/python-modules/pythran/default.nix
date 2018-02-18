{ lib, buildPythonPackage, fetchPypi, ply, networkx2, decorator, gast, six }:

buildPythonPackage rec {
  pname = "pythran";
  version = "0.8.4.post0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1df5496298ae31dfe237f5069e6e5689157647f590cd8f304ace55285b771b5c";
  };

  propagatedBuildInputs = [ ply networkx2 decorator gast six ];

  meta = {
    description = "A claimless python to c++ converter";
    homepage = https://github.com/serge-sans-paille/gast;
    license = lib.licenses.bsd3;
    maintainers =  with lib.maintainers; [ mredaelli ];
  };
}
