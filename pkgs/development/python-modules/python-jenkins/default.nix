{ stdenv
, buildPythonPackage
, fetchPypi
, python
, mock
, pbr
, pyyaml
, six
, multi_key_dict
, testtools
, testscenarios
, testrepository
, kerberos
}:

buildPythonPackage rec {
  pname = "python-jenkins";
  version = "1.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b44b3c8e0dabed371a1a8a301cc8833c635625faf003fd68c176800c71a6597c";
  };

  patchPhase = ''
    sed -i 's@python@${python.interpreter}@' .testr.conf
  '';

  buildInputs = [ mock ];
  propagatedBuildInputs = [ pbr pyyaml six multi_key_dict testtools testscenarios testrepository kerberos ];

  meta = with stdenv.lib; {
    description = "Python bindings for the remote Jenkins API";
    homepage = https://pypi.python.org/pypi/python-jenkins;
    license = licenses.bsd3;
  };

}
