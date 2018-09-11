{ stdenv
, buildPythonPackage
, fetchPypi
, pbr
, six
, wrapt
, funcsigs
, hacking
, coverage
, subunit
, sphinx
, openstackdocstheme
, stestr
, testtools
, fixtures
, doc8
, reno
}:

buildPythonPackage rec {
  version = "1.20.0";
  pname = "debtcollector";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f48639881e0dd492e3576fd714e2a4e422492bb586b9f90affe0f093d7a09ac8";
  };

  checkInputs = [ hacking coverage subunit sphinx openstackdocstheme stestr testtools fixtures doc8 reno ];
  propagatedBuildInputs = [ pbr six wrapt funcsigs ];

  # relax hacking dependency contstraint
  patchPhase = ''
    sed -i 's/hacking<0.11,>=0.10.0/hacking>0.10.0/' test-requirements.txt
  '';

  meta = with stdenv.lib; {
    homepage = https://docs.openstack.org/debtcollector/latest;
    description = "A collection of Python deprecation patterns and strategies that help you collect your technical debt in a non-destructive manner";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
