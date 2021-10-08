{ lib, buildPythonPackage, fetchPypi, dnspython, pycountry, nose, setuptools-scm, six, isPy27 }:

buildPythonPackage rec {
  pname = "FormEncode";
  version = "2.0.1";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "8f2974112c2557839d5bae8b76490104c03830785d923abbdef148bf3f710035";
  };

  postPatch = ''
    sed -i 's/setuptools_scm_git_archive//' setup.py
    sed -i 's/use_scm_version=.*,/version="${version}",/' setup.py
  '';

  nativeBuildInputs = [ setuptools-scm ];
  propagatedBuildInputs = [ six ];

  checkInputs = [ dnspython pycountry nose ];

  preCheck = ''
    # requires dns resolving
    sed -i 's/test_unicode_ascii_subgroup/noop/' formencode/tests/test_email.py
  '';

  meta = with lib; {
    description = "FormEncode validates and converts nested structures";
    homepage = "http://formencode.org";
    license = licenses.mit;
  };
}
