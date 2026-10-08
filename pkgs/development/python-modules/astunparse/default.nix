{
  lib,
  fetchPypi,
  buildPythonPackage,
  setuptools,
  six,
}:

buildPythonPackage rec {
  pname = "astunparse";
  version = "1.6.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "5ad93a8456f0d084c3456d059fd9a92cce667963232cbf763eac3bc5b7940872";
  };

  build-system = [ setuptools ];

  dependencies = [
    six
  ];

  # tests not included with pypi release
  doCheck = false;

  meta = {
    description = "This is a factored out version of unparse found in the Python source distribution";
    homepage = "https://github.com/simonpercivall/astunparse";
    license = lib.licenses.bsd3;
  };
}
