{ gevent
, buildPythonPackage
, fetchFromGitHub
, hostname
, pytest
, python
, stdenv
}:

buildPythonPackage rec {
  pname = "ruffus";
  version = "2.8.1";

  src = fetchFromGitHub {
    owner = "cgat-developers";
    repo = pname;
    rev = "v${version}";
    sha256 = "1gyabqafq4s2sy0prh3k1m8859shzjmfxr7fimx10liflvki96a9";
  };

  propagatedBuildInputs = [ gevent ];

  postPatch = ''
    sed -i -e 's|/bin/bash|${stdenv.shell}|'          ruffus/test/Makefile
    sed -i -e 's|\tpytest|\t${pytest}/bin/pytest|'    ruffus/test/Makefile
    sed -i -e 's|\tpython|\t${python.interpreter}|'   ruffus/test/Makefile
    sed -i -e 's|/usr/bin/env bash|${stdenv.shell}|'  ruffus/test/run_all_unit_tests.cmd
    sed -i -e 's|python3|${python.interpreter}|'      ruffus/test/run_all_unit_tests3.cmd
    sed -i -e 's|python %s|${python.interpreter} %s|' ruffus/test/test_drmaa_wrapper_run_job_locally.py
  '';

  makefile = "ruffus/test/Makefile";

  checkInputs = [
    gevent
    hostname
    pytest
  ];

  checkPhase = ''
    export HOME=$TMPDIR
    cd ruffus/test
    make all PYTEST_OPTIONS="-q --disable-warnings"
  '';

  meta = with stdenv.lib; {
    description = "Light-weight Python Computational Pipeline Management";
    homepage = "http://www.ruffus.org.uk";
    license = licenses.mit;
    maintainers = [ maintainers.kiwi ];
  };
}

