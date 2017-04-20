{ stdenv
, fetchFromGitHub
, cmake
, python
}:

# This is a header-only package.

# Note that there is also a package on PyPI.
# That version is installable with buildPythonPackage / setuptools,
# but it cannot run the tests.

stdenv.mkDerivation rec {
  pname = "pybind11";
  version = "2.1.1";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "pybind";
    repo = "pybind11";
    rev = "v2.1.1";
    sha256 = "1qhnd1yr38zr71j01nnf992m3rbfghx9fdpqhqssm6zbdxlvkdqn";
  };

  buildInputs = [ cmake python.pkgs.pytest ];

  meta = {
    description = "Seamless operability between C++11 and Python";
    homepage = https://github.com/wjakob/pybind11;
    license = stdenv.lib.licenses.bsd3;
  };
}