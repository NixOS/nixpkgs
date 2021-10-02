{ lib
, buildPythonPackage
, isPy27
, fetchPypi
, distro
, httplib2
, oauthlib
, setuptools
, six
, wadllib
, fixtures
, lazr-uri
, pytestCheckHook
, wsgi-intercept
}:

buildPythonPackage rec {
  pname = "lazr.restfulclient";
  version = "0.14.4";

  disabled = isPy27; # namespace is broken for python2

  src = fetchPypi {
    inherit pname version;
    sha256 = "bf0fd6b2749b3a2d02711f854c9d23704756f7afed21fb5d5b9809d72aa6d087";
  };

  propagatedBuildInputs = [ distro httplib2 oauthlib setuptools six wadllib ];

  # E   ModuleNotFoundError: No module named 'lazr.uri'
  doCheck = false;
  checkInputs = [ fixtures lazr-uri pytestCheckHook wsgi-intercept ];

  pythonImportsCheck = [ "lazr.restfulclient" ];

  meta = with lib; {
    description = "A programmable client library that takes advantage of the commonalities among";
    homepage = "https://launchpad.net/lazr.restfulclient";
    license = licenses.lgpl3;
    maintainers = [ maintainers.marsam ];
  };
}
