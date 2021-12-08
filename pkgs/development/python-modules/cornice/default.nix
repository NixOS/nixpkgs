{ lib
, buildPythonPackage
, fetchFromGitHub
, pyramid
, simplejson
, six
, venusian
}:

buildPythonPackage rec {
  pname = "cornice";
  version = "6.0.0";

  src = fetchFromGitHub {
     owner = "mozilla-services";
     repo = "cornice";
     rev = "6.0.0";
     sha256 = "14n8n7adxhigybbdam5lsnz4j6rrblxiwanl6fwxbi6jk0d7an2n";
  };

  propagatedBuildInputs = [ pyramid simplejson six venusian ];

  # tests not packaged with pypi release
  doCheck = false;
  pythonImportsCheck = [ "cornice" ];

  meta = with lib; {
    homepage = "https://github.com/mozilla-services/cornice";
    description = "Build Web Services with Pyramid";
    license = licenses.mpl20;
    maintainers = [ maintainers.costrouc ];
  };
}
