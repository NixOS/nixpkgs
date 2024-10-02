{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pkgs,
  setuptools,
}:

buildPythonPackage rec {
  pname = "hwdata";
  version = "2.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "xsuchy";
    repo = "python-hwdata";
    rev = "python-hwdata-${version}-1";
    hash = "sha256-hmvxVF9LOkezXnJdbtbEJWhU4uvUJgxQHYeWUoiniF0=";
  };

  nativeBuildInputs = [ setuptools ];

  patchPhase = ''
    substituteInPlace hwdata.py --replace "/usr/share/hwdata" "${pkgs.hwdata}/share/hwdata"
  '';

  pythonImportsCheck = [ "hwdata" ];

  doCheck = false; # no tests

  meta = with lib; {
    description = "Python bindings to hwdata";
    homepage = "https://github.com/xsuchy/python-hwdata";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ lurkki ];
  };
}
