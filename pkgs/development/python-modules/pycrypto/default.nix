{ buildPythonPackage, pycryptodome }:

# This is a dummy package providing the drop-in replacement pycryptodome.
# https://github.com/NixOS/nixpkgs/issues/21671

buildPythonPackage rec {
  pname = "pycrypto";
  version = pycryptodome.version;

  # Cannot build wheel otherwise (zip 1980 issue)
  SOURCE_DATE_EPOCH=315532800;

  # We need to have a dist-info folder, so let's create one with setuptools
  unpackPhase = ''
    echo "from setuptools import setup; setup(name='${pname}', version='${version}', install_requires=['pycryptodome'])" > setup.py
  '';

  propagatedBuildInputs = [ pycryptodome ];

  # Our dummy has no tests
  doCheck = false;

  meta = {
    homepage = "https://www.pycrypto.org/";
    description = "Drop-in replacement for pycrypto using pycryptodome";
    platforms = pycryptodome.meta.platforms;
  };
}
