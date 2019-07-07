{ stdenv, buildPythonPackage, fetchPypi, isPy3k, mock }:

buildPythonPackage rec {
  pname = "darcsver";
  version = "1.7.4";

  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1yb1c3jxqvy4r3qiwvnb86qi5plw6018h15r3yk5ji3nk54qdcb6";
  };

  buildInputs = [ mock ];

  # Note: We don't actually need to provide Darcs as a build input.
  # Darcsver will DTRT when Darcs isn't available.  See news.gmane.org
  # http://thread.gmane.org/gmane.comp.file-systems.tahoe.devel/3200 for a
  # discussion.

  # AttributeError: 'module' object has no attribute 'test_darcsver'
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Darcsver, generate a version number from Darcs history";
    homepage = https://pypi.python.org/pypi/darcsver;
    license = "BSD-style";
  };
}
