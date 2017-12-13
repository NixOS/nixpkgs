{ lib, buildPythonPackage, isPyPy, fetchPypi, python, isPy3k
, pbr, testtools, testresources, testrepository, mock
, pep8, fixtures, mox3, requests-mock
, iso8601, requests, six, stevedore, webob, oslo-config
, pyyaml, betamax, oauthlib, stestr, sphinx
, reno, openstackdocstheme, bandit
}:

buildPythonPackage rec {
  pname = "keystoneauth1";
  version = "3.3.0";
  disabled = isPyPy; # a test fails

  src = fetchPypi {
    inherit pname version;
    sha256 = "1vcx8sp699pr6s0z0sww3c9awbhfxqrq3w8vlpwj7mn0acpjvny8";
  };

  buildInputs = [ pbr ];
  checkInputs = [
    pyyaml betamax oauthlib testtools testresources
    testrepository mock pep8 fixtures mox3 requests-mock
    stestr sphinx reno openstackdocstheme bandit
  ];
  propagatedBuildInputs = [ iso8601 requests six stevedore webob ];

  doCheck = true;
  # 1. oslo-config
  # 2. oslo-utils
  # 3. requests-kerberos
  # 4. Nonetype is not callable with py3k
  # 5. infinite recursion
  preCheck = ''
    rm keystoneauth1/tests/unit/loading/test_{session,conf,adapter,fixtures}.py
    rm keystoneauth1/tests/unit/access/test_v{2,3}_access.py
    rm keystoneauth1/tests/unit/extras/kerberos/test_fedkerb_loading.py
    ${lib.optionalString (isPy3k) "rm keystoneauth1/tests/unit/identity/{test_password,test_token,utils}.py"}
    sed -i 's/run.py/nix_run_setup.py/' keystoneauth1/tests/unit/test_session.py
    sed -i -e '/os-testr/d' -e '/oslotest/d' -e '/oslo.utils/d' \
      -e '/oslo.config/d' -e '/flake8-docstrings/d' -e '/hacking/d' \
      test-requirements.txt
  '';

  meta = {
    homepage = https://github.com/openstack/keystoneauth;
    description = "OpenStack Identity Authentication Library";
  };
}
