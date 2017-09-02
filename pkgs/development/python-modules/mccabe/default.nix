{ stdenv, buildPythonPackage, fetchPypi, pytest, pytestrunner }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "mccabe";
  version = "0.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "07w3p1qm44hgxf3vvwz84kswpsx6s7kvaibzrsx5dzm0hli1i3fx";
  };

  buildInputs = [ pytest pytestrunner ];

  meta = with stdenv.lib; {
    description = "McCabe checker, plugin for flake8";
    homepage = https://github.com/flintwork/mccabe;
    license = licenses.mit;
    maintainers = with maintainers; [ garbas ];
  };
}
