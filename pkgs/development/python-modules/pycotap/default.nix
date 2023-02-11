{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "pycotap";
  version = "1.2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-+Tjs1JMczRnZWY+2M9Xqu3k48IuEcXMV5SUmqmJ3yew=";
  };

  meta = with lib; {
    description = "Test runner for unittest that outputs TAP results to stdout";
    homepage = "https://el-tramo.be/pycotap";
    license = licenses.mit;
    maintainers = with maintainers; [ mwolfe ];
  };
}
