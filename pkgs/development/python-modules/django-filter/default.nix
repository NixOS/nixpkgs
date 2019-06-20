{ stdenv
, fetchPypi, fetchpatch
, buildPythonPackage, pythonOlder
, django, python, django-crispy-forms, mock, djangorestframework
}:
buildPythonPackage rec {

  pname = "django-filter";
  version = "2.1.0";

  disabled = pythonOlder "3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3dafb7d2810790498895c22a1f31b2375795910680ac9c1432821cbedb1e176d";
  };

  # Big thanks to `risicle` for helping out with this patch!
  patches = [ (fetchpatch {
    name = "fix-dst-test.patch";
    url = https://github.com/carltongibson/django-filter/pull/1058/commits/9c0b06610dbd5b69a006ae121d383ef49cc70fff.patch;
    sha256 = "0rrbqxjcwwkcldxi1q38cf2wcl9rgk7yyyc6rxwswi45r9sxihgb";
  }) ];

  propagatedBuildInputs = [ django ];
  
  checkInputs = [
    djangorestframework
    mock
    django-crispy-forms
  ];

  checkPhase = "${python.interpreter} runtests.py";

  meta = with stdenv.lib; {
    homepage = "https://github.com/carltongibson/django-filter/tree/master";
    license = licenses.bsdOriginal;
    description = "Django-filter is a reusable Django application for allowing users to filter querysets dynamically.";
    maintainers = with maintainers; [ BadDecisionsAlex ];
  };

}
