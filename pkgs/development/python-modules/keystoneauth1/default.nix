{ buildPythonPackage, isPyPy, fetchPypi, python
, pbr, testtools, testresources, testrepository, mock
, pep8, fixtures, mox3, requests-mock
, iso8601, requests, six, stevedore, webob, oslo-config
, pyyaml, betamax, oauthlib
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

  buildInputs = [ pbr  ];
  checkInputs = [ pyyaml betamax oauthlib testtools testresources
                  testrepository mock pep8 fixtures mox3 requests-mock ];
  propagatedBuildInputs = [ iso8601 requests six stevedore webob ];

  doCheck = true;
  # 1. oslo-config
  # 2. oslo-utils
  # 3. requests-kerberos
  preCheck = ''
    rm keystoneauth1/tests/unit/loading/test_{session,conf,adapter}.py
    rm keystoneauth1/tests/unit/access/test_v{2,3}_access.py
    rm keystoneauth1/tests/unit/extras/kerberos/test_fedkerb_loading.py
  '';
  postPatch = ''
    sed -i 's@python@${python.interpreter}@' .testr.conf
    substituteInPlace requirements.txt --replace "argparse" ""
  '';
}
