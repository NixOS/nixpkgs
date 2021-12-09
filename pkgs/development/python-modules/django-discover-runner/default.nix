{ lib
, buildPythonPackage
, fetchFromGitHub
, django
}:

buildPythonPackage rec {
  version = "1.0";
  pname = "django-discover-runner";

  src = fetchFromGitHub {
     owner = "jezdez";
     repo = "django-discover-runner";
     rev = "1.0";
     sha256 = "0v25pgcyqwc4n9p073zqy2f60q1wpyal10x77f18q3vyxk0lpg8g";
  };

  propagatedBuildInputs = [ django ];

  # tests not included with release
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/jezdez/django-discover-runner";
    description = "A Django test runner based on unittest2's test discovery";
    license = licenses.bsd0;
    maintainers = [ maintainers.costrouc ];
  };
}
