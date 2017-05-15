{ stdenv
, buildPythonPackage
, fetchPypi
, python
, numpy
, scipy
, six
, smart_open
, testfixtures
, unittest2
, pyro4
, pyemd
, scikitlearn
, morfessor
}:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "gensim";
  version = "2.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1wn7bji9b80wn1yggmh7a0dlwzdjr6cp24x4p33j2rf29lxnm2kc";
  };

  propagatedBuildInputs = [
    numpy
    scipy
    six
    smart_open
  ];
  
  buildInputs = [
    testfixtures
    unittest2
    pyro4
    pyemd
    scikitlearn
    morfessor
  ];

  checkPhase = ''
    ${python.interpreter} setup.py test
  '';
  
  meta = with stdenv.lib; {
    description = "a Python library for topic modelling, document indexing and similarity retrieval with large corpora";
    homepage = https://github.com/RaRe-Technologies/gensim;
    license = licenses.lgpl21;
    maintainers = with maintainers; [ sdll ];
    };
}
