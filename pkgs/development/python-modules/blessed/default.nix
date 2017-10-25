{ stdenv, buildPythonPackage, fetchPypi, six, wcwidth }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "blessed";
  version = "1.14.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0fv9f0074kxy1849h0kwwxw12sifpq3bv63pcz900zzjsigi4hi3";
  };

  propagatedBuildInputs = [ wcwidth six ];

  meta = with stdenv.lib; {
    homepage = https://github.com/jquast/blessed;
    description = "A thin, practical wrapper around terminal capabilities in Python.";
    maintainers = with maintainers; [ eqyiel ];
    license = licenses.mit;
  };
}
