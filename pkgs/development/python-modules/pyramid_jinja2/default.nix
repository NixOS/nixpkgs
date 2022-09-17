{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, webtest
, markupsafe
, jinja2
, pytestCheckHook
, zope_deprecation
, pyramid
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyramid-jinja2";
  version = "2.10";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "pyramid_jinja2";
    inherit version;
    hash = "sha256-8nEGnZ6ay6x622kSGQqEj2M49+V6+68+lSN/6DzI9NI=";
  };

  propagatedBuildInputs = [
    markupsafe
    jinja2
    pyramid
    zope_deprecation
  ];

  checkInputs = [
    webtest
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace " --cov" ""
  '';

  pythonImportsCheck = [
    "pyramid_jinja2"
  ];

  disabledTests = [
    # AssertionError: Lists differ: ['pyramid_jinja2-2.10',...
    "test_it_relative_to_package"
    # AssertionError: False is not true
    "test_options"
  ];

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64) || stdenv.isDarwin;
    description = "Jinja2 template bindings for the Pyramid web framework";
    homepage = "https://github.com/Pylons/pyramid_jinja2";
    license = licenses.bsd0;
    maintainers = with maintainers; [ domenkozar ];
  };
}
