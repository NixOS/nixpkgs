{ lib, fetchPypi, isPy3k, buildPythonPackage, numpy, matplotlib, root, root_numpy, tables }:

buildPythonPackage rec {
  pname = "rootpy";
  version = "1.0.1";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0zp2bh87l3f0shiqslbvfmavfdj8m80y8fsrz8rsi5pzqj7zr1bx";
  };

  disabled = isPy3k;

  propagatedBuildInputs = [ matplotlib numpy root root_numpy tables ];

  meta = with lib; {
    homepage = http://www.rootpy.org;
    license = licenses.bsd3;
    description = "Pythonic interface to the ROOT framework";
    maintainers = with maintainers; [ veprbl ];
  };
}
