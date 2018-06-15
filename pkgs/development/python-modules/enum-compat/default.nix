{ lib, buildPythonPackage, fetchPypi, enum34 }:

buildPythonPackage rec {
  pname = "enum-compat";
  version = "0.0.2";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "14j1i963jic2vncbf9k5nq1vvv8pw2zsg7yvwhm7d9c6h7qyz74k";
  };

  propagatedBuildInputs = [ enum34 ];

  meta = with lib; {
    homepage = https://github.com/jstasiak/enum-compat;
    description = "enum/enum34 compatibility package";
    license = licenses.mit;
    maintainers = with maintainers; [ abbradar ];
  };
}
