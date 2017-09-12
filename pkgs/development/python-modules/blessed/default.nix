{ stdenv, buildPythonPackage, fetchPypi, wcwidth, six, pytest, mock }:

buildPythonPackage rec {
  pname = "blessed";
  name = "${pname}-${version}";
  version = "1.14.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0fv9f0074kxy1849h0kwwxw12sifpq3bv63pcz900zzjsigi4hi3";
  };

  propagatedBuildInputs = [ wcwidth six ];

  checkInputs = [ pytest mock ];
  
  meta = with stdenv.lib; {
    description = "A thin, practical wrapper around terminal styling, screen positioning, and keyboard input";
    homepage = https://github.com/jquast/blessed;
    license = licenses.mit;
  };
}
