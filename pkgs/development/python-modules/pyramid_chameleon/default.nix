{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, chameleon
, pyramid
, zope_interface
, setuptools
}:

buildPythonPackage rec {
  pname = "pyramid_chameleon";
  version = "0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d176792a50eb015d7865b44bd9b24a7bd0489fa9a5cebbd17b9e05048cef9017";
  };

  patches = [
    # https://github.com/Pylons/pyramid_chameleon/pull/25
    ./test-renderers-pyramid-import.patch
  ];

  propagatedBuildInputs = [ chameleon pyramid zope_interface setuptools ];

  pythonImportsCheck = [ "pyramid_chameleon" ];

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64) || stdenv.isDarwin;
    description = "Chameleon template compiler for pyramid";
    homepage = "https://github.com/Pylons/pyramid_chameleon";
    license = licenses.bsd0;
    maintainers = with maintainers; [ domenkozar ];
  };
}
