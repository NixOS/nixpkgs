{ lib
, buildPythonPackage
, isPy27
, fetchPypi
, setuptools-scm
, six
, dnspython
, pycountry
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "formencode";
  version = "2.0.1";

  disabled = isPy27;

  src = fetchPypi {
    pname = "FormEncode";
    inherit version;
    sha256 = "8f2974112c2557839d5bae8b76490104c03830785d923abbdef148bf3f710035";
  };

  postPatch = ''
    sed -i '/setuptools_scm_git_archive/d' setup.py
  '';

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [ six ];

  nativeCheckInputs = [
    dnspython
    pycountry
    pytestCheckHook
  ];

  disabledTests = [
    # requires network for DNS resolution
    "test_doctests"
    "test_unicode_ascii_subgroup"
  ];

  meta = with lib; {
    description = "FormEncode validates and converts nested structures";
    homepage = "http://formencode.org";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
