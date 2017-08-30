{ buildPythonPackage, isPyPy, fetchPypi, python
, pbr, testtools, testresources, testrepository, mock
, pep8, fixtures, mox3, requests-mock
, iso8601, requests, six, stevedore, webob, oslo-config
}:

buildPythonPackage rec {
  pname = "keystoneauth1";
  version = "3.1.0";
  name = "${pname}-${version}";
  disabled = isPyPy; # a test fails

  src = fetchPypi {
    inherit pname version;
    sha256 = "e5abfa8bbe866d52ca56afbe528d15214a60033cc1dc9804478cae7424f0f8fb";
  };

  buildInputs = [ pbr testtools testresources testrepository mock
                  pep8 fixtures mox3 requests-mock ];
  propagatedBuildInputs = [ iso8601 requests six stevedore
                            webob oslo-config ];

  postPatch = ''
    sed -i 's@python@${python.interpreter}@' .testr.conf
    substituteInPlace requirements.txt --replace "argparse" ""
  '';
}
