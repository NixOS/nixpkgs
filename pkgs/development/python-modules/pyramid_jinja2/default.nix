{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, webtest
, jinja2
, pyramid
}:

buildPythonPackage rec {
  pname = "pyramid_jinja2";
  version = "2.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-8nEGnZ6ay6x622kSGQqEj2M49+V6+68+lSN/6DzI9NI=";
  };

  buildInputs = [ webtest ];
  propagatedBuildInputs = [ jinja2 pyramid ];

  pythonImportsCheck = [ "pyramid_jinja2" ];

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64) || stdenv.isDarwin;
    description = "Jinja2 template bindings for the Pyramid web framework";
    homepage = "https://github.com/Pylons/pyramid_jinja2";
    license = licenses.bsd0;
    maintainers = with maintainers; [ domenkozar ];
  };
}
