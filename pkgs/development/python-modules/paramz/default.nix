{ stdenv, buildPythonPackage, fetchPypi, numpy, scipy, six, decorator }:

buildPythonPackage rec {
  pname = "paramz";
  version = "0.9.2";
  name  = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7b38c2487602c423ac402214c3b3fa6bbe22b294e2f9e5f9f3842182e1541599";
  };

  propagatedBuildInputs = [ numpy scipy six decorator ];

  meta = with stdenv.lib; {
    description = "Parameterization framework for parameterized model creation and handling";
    homepage = https://github.com/sods/paramz;
    license = licenses.bsd3;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
