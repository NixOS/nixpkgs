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
  version = "1.0.0";
  disabled = isPyPy || isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "9f6fcca349ebf2ec04ca7eacb076aea3e4fcdc010ac33c98b54f0a19d4e5d3e0";
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
