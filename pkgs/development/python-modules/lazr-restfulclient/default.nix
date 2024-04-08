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
  version = "0.14.6";

  disabled = isPy27; # namespace is broken for python2

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Q/EqHTlIRjsUYgOMR7Qp3LXkLgun8uFlEbArpdKt/9s=";
  };

  propagatedBuildInputs = [ distro httplib2 oauthlib setuptools six wadllib ];

  # E   ModuleNotFoundError: No module named 'lazr.uri'
  doCheck = false;
  nativeCheckInputs = [ fixtures lazr-uri pytestCheckHook wsgi-intercept ];

  pythonImportsCheck = [ "lazr.restfulclient" ];

  meta = with lib; {
    description = "A programmable client library that takes advantage of the commonalities among";
    homepage = "https://launchpad.net/lazr.restfulclient";
    license = licenses.lgpl3;
    maintainers = [ maintainers.marsam ];
  };
}
