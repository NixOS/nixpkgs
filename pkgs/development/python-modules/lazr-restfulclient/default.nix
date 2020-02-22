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
}:

buildPythonPackage rec {
  pname = "lazr.restfulclient";
  version = "0.14.3";

  disabled = isPy27; # namespace is broken for python2

  src = fetchPypi {
    inherit pname version;
    sha256 = "9f28bbb7c00374159376bd4ce36b4dacde7c6b86a0af625aa5e3ae214651a690";
  };

  propagatedBuildInputs = [ distro httplib2 oauthlib setuptools six wadllib ];

  doCheck = false; # requires to package lazr.restful, lazr.authentication, and wsgi_intercept

  pythonImportsCheck = [ "lazr.restfulclient" ];

  meta = with lib; {
    description = "A programmable client library that takes advantage of the commonalities among";
    homepage = "https://launchpad.net/lazr.restfulclient";
    license = licenses.lgpl3;
    maintainers = [ maintainers.marsam ];
  };
}
