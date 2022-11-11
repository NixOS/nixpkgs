{ buildPythonPackage, django, fetchPypi, lib, typing-extensions }:

buildPythonPackage rec {
  pname = "django-stubs-ext";
  version = "0.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-m9dBg3arALf4jW1Wvp/s6Fv6DHw0isYhFV+k16kRRvI=";
  };

  # setup.cfg tries to pull in nonexistent LICENSE.txt file
  postPatch = "rm setup.cfg";

  propagatedBuildInputs = [ django typing-extensions ];

  meta = with lib; {
    description = "Extensions and monkey-patching for django-stubs";
    homepage = "https://github.com/typeddjango/django-stubs";
    license = licenses.mit;
    maintainers = with maintainers; [ elohmeier ];
  };
}
