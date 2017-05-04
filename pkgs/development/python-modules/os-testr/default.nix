{ stdenv, buildPythonPackage, fetchurl, python,
  pbr, Babel, testrepository, subunit, testtools,
  coverage, oslosphinx, oslotest, testscenarios, six, ddt 
}:
buildPythonPackage rec {
  name = "os-testr-${version}";
  version = "0.8.1";

  src = fetchurl {
    url = "mirror://pypi/o/os-testr/${name}.tar.gz";
    sha256 = "10ws7l5p25psnp6rwymwdzh4zagmmnbf56xwg06cn2292m95l4i7";
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
