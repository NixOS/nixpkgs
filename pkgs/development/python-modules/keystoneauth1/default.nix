{ buildPythonPackage, isPyPy, fetchPypi, python
, pbr, testtools, testresources, testrepository, mock
, pep8, fixtures, mox3, requests-mock
, iso8601, requests, six, stevedore, webob, oslo-config
}:

buildPythonPackage rec {
  pname = "keystoneauth1";
  version = "3.2.0";
  name = "${pname}-${version}";
  disabled = isPyPy; # a test fails

  src = fetchPypi {
    inherit pname version;
    sha256 = "0rg3harfyvai34lrjiqnl1crmvswjvj8nsviasnz4b9pcvp3d03n";
  };

  buildInputs = [ pbr testtools testresources testrepository mock
                  pep8 fixtures mox3 requests-mock ];
  propagatedBuildInputs = [ iso8601 requests six stevedore webob ];

  # oslo_config is required but would create a circular dependency
  doCheck = false;
  postPatch = ''
    sed -i 's@python@${python.interpreter}@' .testr.conf
    substituteInPlace requirements.txt --replace "argparse" ""
  '';
}
