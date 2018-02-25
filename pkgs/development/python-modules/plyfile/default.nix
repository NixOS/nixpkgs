{ lib, fetchPypi, buildPythonPackage, numpy
}:

buildPythonPackage rec {
  pname = "plyfile";
  version = "0.5";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1cspvhfy2nw1rfwpvrd69wkz0b6clr4wzqpwpmdk872vk2q89yzi";
  };

  propagatedBuildInputs = [ numpy ];

  meta = with lib; {
    description = "NumPy-based text/binary PLY file reader/writer for Python";
    homepage    = https://github.com/dranjan/python-plyfile;
    maintainers = with maintainers; [ abbradar ];
  };

}
