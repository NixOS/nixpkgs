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
  version = "2.1.0";
  format = "setuptools";

  disabled = isPy27;

  src = fetchPypi {
    pname = "FormEncode";
    inherit version;
    sha256 = "sha256-63TSIweKKM8BX6iJZsbjTy0Y11EnMY1lwUS+2a/EJj8=";
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
