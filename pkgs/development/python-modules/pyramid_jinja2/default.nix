{ lib
, buildPythonPackage
, fetchPypi
, webtest
, jinja2
, pyramid
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pyramid_jinja2";
  version = "2.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-8nEGnZ6ay6x622kSGQqEj2M49+V6+68+lSN/6DzI9NI=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "--cov" ""
  '';

  buildInputs = [
    webtest
  ];

  propagatedBuildInputs = [
    jinja2
    pyramid
  ];

  checkInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # mismatch in the expected package path:
    #   wants: pyramid_jinja2
    #   gets:  pyramid_jinja2-2.10
    "test_options"
    "test_it_relative_to_package"
  ];

  pythonImportsCheck = [ "pyramid_jinja2" ];

  meta = with lib; {
    description = "Jinja2 template bindings for the Pyramid web framework";
    homepage = "https://github.com/Pylons/pyramid_jinja2";
    license = licenses.bsd0;
    maintainers = with maintainers; [ domenkozar ];
  };
}
