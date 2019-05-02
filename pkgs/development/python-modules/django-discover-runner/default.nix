{ stdenv
, buildPythonPackage
, fetchPypi
, django
}:

buildPythonPackage rec {
  version = "1.0";
  pname = "django-discover-runner";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ba91fe722c256bcbfdeb36fac7eac0f27e5bfda55d98c4c1cf9ab62b5b084fe";
  };

  propagatedBuildInputs = [ django ];

  # tests not included with release
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/jezdez/django-discover-runner;
    description = "A Django test runner based on unittest2's test discovery";
    license = licenses.bsd0;
    maintainers = [ maintainers.costrouc ];
  };
}
