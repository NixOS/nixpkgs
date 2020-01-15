{ stdenv, buildPythonPackage, fetchPypi, fetchpatch
, cython, pytest, pytestrunner, hypothesis }:

buildPythonPackage rec {
  pname = "datrie";
  version = "0.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "08r0if7dry2q7p34gf7ffyrlnf4bdvnprxgydlfxgfnvq8f3f4bs";
  };

  patches = [
    # fix tests against recent hypothesis
    (fetchpatch {
      url = "https://github.com/pytries/datrie/commit/9b24b4c02783cdb703ac3f6c6d7d881db93166e0.diff";
      sha256 = "1ql7jcf57q3x3fcbddl26y9kmnbnj2dv6ga8mwq94l4a3213j2iy";
    })
  ];

  nativeBuildInputs = [ cython ];
  buildInputs = [ pytest pytestrunner hypothesis ];

  # recompile pxd and pyx for python37
  # https://github.com/pytries/datrie/issues/52
  preBuild = ''
    ./update_c.sh
  '';

  meta = with stdenv.lib; {
    description = "Super-fast, efficiently stored Trie for Python";
    homepage = "https://github.com/kmike/datrie";
    license = licenses.lgpl2;
    maintainers = with maintainers; [ lewo ];
  };
}
