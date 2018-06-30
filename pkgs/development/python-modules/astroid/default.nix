{ lib, fetchPypi, buildPythonPackage, python, logilab_common, six
, lazy-object-proxy, wrapt, singledispatch, enum34, pythonOlder
, backports_functools_lru_cache
}:

buildPythonPackage rec {
  pname = "astroid";
  version = "1.6.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fc9b582dba0366e63540982c3944a9230cbc6f303641c51483fa547dcc22393a";
  };

  propagatedBuildInputs = [ logilab_common six lazy-object-proxy wrapt ]
    ++ lib.optionals (pythonOlder "3.4") [ enum34 singledispatch]
    ++ lib.optionals (pythonOlder "3.3") [ backports_functools_lru_cache ];

  postPatch = ''
    cd astroid/tests
    for i in $(ls unittest*); do mv -v $i test_$i; done
    cd ../..
    rm -vf astroid/tests/test_unittest_inference.py
    rm -vf astroid/tests/test_unittest_manager.py
  '';

  checkPhase = ''
    ${python.interpreter} -m unittest discover
  '';

  meta = with lib; {
    description = "A abstract syntax tree for Python with inference support";
    homepage = https://bitbucket.org/logilab/astroid;
    license = licenses.lgpl2;
    platforms = platforms.all;
    maintainers = with maintainers; [ nand0p ];
  };
}
