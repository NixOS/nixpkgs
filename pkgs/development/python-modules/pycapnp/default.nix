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
  version = "0.6.4";
  disabled = isPyPy || isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "44e14a5ace399cf1753acb8bbce558b8c895c48fd2102d266c34eaff286824cf";
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
