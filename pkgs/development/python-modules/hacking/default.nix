{ lib 
, stdenv
, buildPythonPackage
, python
, fetchPypi
, flake8
, pbr
, reno
, six
}:

buildPythonPackage rec{
  pname = "hacking";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "23a306f3a1070a4469a603886ba709780f02ae7e0f1fc7061e5c6fb203828fee";
  };

  buildInputs = [ flake8 pbr reno six ];

  patchPhase = ''
    sed -i 's@flake8<2.7.0,>=2.6.0@flake8>=2.6.0@' requirements.txt
    sed -i 's@python@${python.interpreter}@' .testr.conf
  '';

  meta = with lib; {
    homepage = https://github.com/openstack-dev/hacking;
    description = "OpenStack Hacking Style Checks";
    license = licenses.apache;
    maintainers = with maintainers; [ cptMikky ];
  };
}

