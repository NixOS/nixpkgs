{ stdenv, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "nvidia-ml-py3";
  version = "7.352.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0xqjypqj0cv7aszklyaad7x3fsqs0q0k3iwq7bk3zmz9ks8h43rr";
  };

  meta = with stdenv.lib; {
    description = "Python Bindings for the NVIDIA Management Library";
    homepage = "https://www.nvidia.com/en-us/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ eadwu ];
  };
}
