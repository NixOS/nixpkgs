{ stdenv, buildPythonPackage, fetchPypi }:
let
  pname = "first";
  version = "2.0.1";
in
buildPythonPackage {
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0pn9hl2y0pz61la1xhkdz6vl9i2dg3nh0ksizcf0f9ybh8sxxcrv";
  };

  doCheck = false; # no tests

  meta = with stdenv.lib; {
    description = "The function you always missed in Python";
    homepage = https://github.com/hynek/first/;
    license = licenses.mit;
    maintainers = with maintainers; [ zimbatm ];
  };
}
