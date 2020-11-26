{ lib
, buildPythonPackage
, fetchPypi
, six
, isPyPy
}:


buildPythonPackage rec {
  pname = "greenlet";
  version = "0.4.17";
  disabled = isPyPy;  # builtin for pypy

  src = fetchPypi {
    inherit pname version;
    sha256 = "0swdhrcq13bdszv3yz5645gi4ijbzmmhxpb6whcfg3d7d5f87n21";
  };

  propagatedBuildInputs = [ six ];

  # see https://github.com/python-greenlet/greenlet/issues/85
  preCheck = ''
    rm tests/test_leaks.py
  '';

  meta = {
    homepage = "https://pypi.python.org/pypi/greenlet";
    description = "Module for lightweight in-process concurrent programming";
    license = lib.licenses.lgpl2;
  };
}
