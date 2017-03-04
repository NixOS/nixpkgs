{ stdenv, fetchurl, buildPythonPackage, python, logilab_common, six,
  lazy-object-proxy, wrapt }:

  buildPythonPackage rec {
    name = "${pname}-${version}";
    pname = "astroid";
    version = "1.4.9";

    src = fetchurl {
      url = "mirror://pypi/a/${pname}/${name}.tar.gz";
      sha256 = "1mw5q20b80j55vbpcdfl824sbb1q15dhkfbczjnnv8733j4yg0x4";
    };

    propagatedBuildInputs = [ logilab_common six lazy-object-proxy wrapt ];

    postPatch = ''
      cd astroid/tests
      for i in $(ls unittest*); do mv -v $i test_$i; done 
      cd ../..
      rm -vf astroid/tests/test_unittest_inference.py
    '';

    checkPhase = ''
      ${python.interpreter} -m unittest discover
    '';

    meta = with stdenv.lib; {
      description = "A abstract syntax tree for Python with inference support";
      homepage = http://bitbucket.org/logilab/astroid;
      license = licenses.lgpl2;
      platform = platforms.all;
      maintainers = with maintainers; [ nand0p ]; 
    };
  }
