{ stdenv
, buildPythonPackage
, fetchPypi
, capnproto
, cython
, isPyPy
, isPy3k
}:

buildPythonPackage rec {
  pname = "pycapnp";
  version = "0.6.3";
  disabled = isPyPy || isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "b3c5a1fcc93fd02fdc070aeccb89654b87f20bdc740f643cc6378925ed6d4c17";
  };

  buildInputs = [ capnproto cython ];

  # import setuptools as soon as possible, to minimize monkeypatching mayhem.
  postConfigure = ''
    sed -i '3iimport setuptools' setup.py
  '';

  meta = with stdenv.lib; {
    maintainers = with maintainers; [ cstrahan ];
    license = licenses.bsd2;
    homepage = "http://jparyani.github.io/pycapnp/index.html";
    broken = true; # 2018-04-11
  };

}
