{ stdenv, buildPythonPackage, fetchurl, python,
  pbr, Babel, testrepository, subunit, testtools,
  coverage, oslosphinx, oslotest, testscenarios, six, ddt 
}:
buildPythonPackage rec {
  version = "0.8.2";
  pname = "os-testr";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/o/os-testr/${name}.tar.gz";
    sha256 = "d8a60bd56c541714a5cab4d1996c8ddfdb5c7c35393d55be617803048c170837";
  };

  patchPhase = ''
    sed -i 's@python@${python.interpreter}@' .testr.conf
    sed -i 's@python@${python.interpreter}@' os_testr/tests/files/testr-conf
  '';

  checkPhase = ''
    export PATH=$PATH:$out/bin
    ${python.interpreter} setup.py test
  '';

  propagatedBuildInputs = [ pbr Babel testrepository subunit testtools ];
  buildInputs = [ coverage oslosphinx oslotest testscenarios six ddt ];

  meta = with stdenv.lib; {
    description = "A testr wrapper to provide functionality for OpenStack projects";
    homepage  = http://docs.openstack.org/developer/os-testr/;
    license = licenses.asl20;
  };
}
