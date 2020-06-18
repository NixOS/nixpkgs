{ lib, pkgs, buildPythonPackage, fetchPypi, isPy3k
, numpy
}:
buildPythonPackage rec {
  pname = "intel-openmp";
  version = "2020.0.133";
  format = "wheel";

  src = fetchPypi {
    inherit version;
    pname = "intel_openmp";
    format = "wheel";
    platform = "manylinux1_x86_64";
    python = "py2.py3";
    sha256 = "cb9a12b0a1cb3f9c44a75959f687e548dc642a9470be3c63f73bccf291b8dcc8";
  };

  propagatedBuildInputs = [
    numpy
  ];

  meta = {
    homepage = "https://software.intel.com/en-us/articles/empowering-science-with-high-performance-python";
    description = "Intel OpenMP Runtime Library";
    platforms = [ "x86_64-linux" ];
    license = lib.licenses.issl;
    maintainers = with lib.maintainers; [ tbenst ];
  };
}