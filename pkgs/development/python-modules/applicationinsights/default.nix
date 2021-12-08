{ buildPythonPackage
, lib
, fetchFromGitHub
, portalocker
}:

buildPythonPackage rec {
  version = "0.11.10";
  pname = "applicationinsights";

  src = fetchFromGitHub {
     owner = "Microsoft";
     repo = "ApplicationInsights-Python";
     rev = "0.11.10";
     sha256 = "08arvy3pbvfsdnhq0xf639a1gyfi0hzxya1mr1m9wvjrl0zqqy5z";
  };

  propagatedBuildInputs = [ portalocker ];

  meta = with lib; {
    description = "This project extends the Application Insights API surface to support Python";
    homepage = "https://github.com/Microsoft/ApplicationInsights-Python";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
