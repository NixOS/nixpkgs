{ stdenv
, buildPythonPackage
, fetchPypi
, six
, mock
, pyyaml
, nose
}:

buildPythonPackage rec {
  pname = "ddt";
  version = "1.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "898364fc34b27981b925171a0011c174c94633cb678eb1fac05fe7a234c7912c";
  };

  checkInputs = [ nose six mock pyyaml ];

  meta = with stdenv.lib; {
    description = "Data-Driven/Decorated Tests, a library to multiply test cases";
    homepage = https://github.com/txels/ddt;
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
