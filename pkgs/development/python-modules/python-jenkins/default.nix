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
  version = "0.4.14";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1n8ikvd9jf4dlki7nqlwjlsn8wpsx4x7wg4h3d6bkvyvhwwf8yqf";
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
