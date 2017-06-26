{ buildPythonPackage, isPyPy, fetchPypi, python
, pbr, testtools, testresources, testrepository, mock
, pep8, fixtures, mox3, requests-mock
, iso8601, requests, six, stevedore, webob, oslo-config
}:

buildPythonPackage rec {
  pname = "keystoneauth1";
  version = "1.1.0";
  name = "${pname}-${version}";
  disabled = isPyPy; # a test fails

  src = fetchPypi {
    inherit pname version;
    sha256 = "05fc6xsp5mal52ijvj84sf7mrw706ihadfdf5mnq9zxn7pfl4118";
  };

  buildInputs = [ pbr testtools testresources testrepository mock
                  pep8 fixtures mox3 requests-mock ];
  propagatedBuildInputs = [ iso8601 requests six stevedore
                            webob oslo-config ];

  postPatch = ''
    sed -i 's@python@${python.interpreter}@' .testr.conf
    substituteInPlace requirements.txt --replace "argparse"
  '';
}
